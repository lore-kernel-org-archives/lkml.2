Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab2HXJF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:05:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757496Ab2HXJBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:01:20 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 01/13] perf test: Add framework for atomated perf_event_attr tests
Date: Fri, 24 Aug 2012 11:00:32 +0200
Message-Id: <1345798844-27423-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
References: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding automated test to check event's perf_event_attr values.

The idea is run perf session with kidnaping sys_perf_event_open
function. For each sys_perf_event_open call we store the
perf_event_attr data to the file to be checked later against what
we expect.

You can run this by:
  # python ./util/test-attr.py -d ./util/test-attr/ -p ./perf -v

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile          |   1 +
 tools/perf/perf.c            |   2 +
 tools/perf/perf.h            |  10 ++
 tools/perf/util/test-attr.c  | 128 ++++++++++++++++++++
 tools/perf/util/test-attr.py | 272 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 413 insertions(+)
 create mode 100644 tools/perf/util/test-attr.c
 create mode 100644 tools/perf/util/test-attr.py

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 722ddee..746375d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -405,6 +405,7 @@ LIB_OBJS += $(OUTPUT)util/rblist.o
 LIB_OBJS += $(OUTPUT)util/intlist.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
 LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
+LIB_OBJS += $(OUTPUT)util/test-attr.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index e7840e5..94092eb13 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -477,6 +477,8 @@ int main(int argc, const char **argv)
 	}
 	cmd = argv[0];
 
+	test_attr__init();
+
 	/*
 	 * We use PATH to find perf commands, but we prepend some higher
 	 * precedence paths: the "--exec-path" option, the PERF_EXEC_PATH
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 87f4ec6..a67bb75 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -5,6 +5,7 @@ struct winsize;
 
 void get_term_dimensions(struct winsize *ws);
 
+
 #if defined(__i386__)
 #include "../../arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
@@ -168,11 +169,20 @@ static inline unsigned long long rdclock(void)
 	(void) (&_min1 == &_min2);		\
 	_min1 < _min2 ? _min1 : _min2; })
 
+extern bool test_attr__enabled;
+void test_attr__init(void);
+int  test_attr__open(struct perf_event_attr *attr,
+		     pid_t pid, int cpu, int group_fd,
+		     unsigned long flags);
+
 static inline int
 sys_perf_event_open(struct perf_event_attr *attr,
 		      pid_t pid, int cpu, int group_fd,
 		      unsigned long flags)
 {
+	if (unlikely(test_attr__enabled))
+		return test_attr__open(attr, pid, cpu, group_fd, flags);
+
 	return syscall(__NR_perf_event_open, attr, pid, cpu,
 		       group_fd, flags);
 }
diff --git a/tools/perf/util/test-attr.c b/tools/perf/util/test-attr.c
new file mode 100644
index 0000000..dd83954
--- /dev/null
+++ b/tools/perf/util/test-attr.c
@@ -0,0 +1,128 @@
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <inttypes.h>
+#include <linux/types.h>
+#include "../perf.h"
+#include "util.h"
+
+#define ENV "PERF_TEST_ATTR"
+
+bool test_attr__enabled;
+
+static char *dir;
+
+void test_attr__init(void)
+{
+	dir = getenv(ENV);
+	test_attr__enabled = (dir != NULL);
+}
+
+#define BUFSIZE 1024
+
+#define WRITE_ASS(str, fmt, data)					\
+do {									\
+	char buf[BUFSIZE];						\
+	size_t size;							\
+									\
+	size = snprintf(buf, BUFSIZE, #str "=%"fmt "\n", data);		\
+	if (1 != fwrite(buf, size, 1, file)) {				\
+		perror("test attr - failed to write event file");	\
+		return -1;						\
+	}								\
+									\
+} while (0)
+
+static int store_event(int fd, struct perf_event_attr *attr,
+		       pid_t pid, int cpu, int group_fd,
+		       unsigned long flags)
+{
+	FILE *file;
+	char path[PATH_MAX];
+
+	snprintf(path, PATH_MAX, "%s/event-%d", dir, fd);
+
+	file = fopen(path, "w+");
+	if (!file) {
+		perror("test attr - failed to open event file");
+		return -1;
+	}
+
+#define HEADER "[event]\n"
+	if (1 != fwrite(HEADER, sizeof(HEADER) - 1, 1, file)) {
+		perror("test attr - failed to write event file");
+		return -1;
+	}
+#undef HEADER
+
+	/* syscall arguments */
+	WRITE_ASS(fd,       "d", fd);
+	WRITE_ASS(group_fd, "d", group_fd);
+	WRITE_ASS(cpu,      "d", cpu);
+	WRITE_ASS(pid,      "d", pid);
+	WRITE_ASS(flags,   "lu", flags);
+
+	/* struct perf_event_attr */
+
+	WRITE_ASS(type,   PRIu32,  attr->type);
+	WRITE_ASS(size,   PRIu32,  attr->size);
+	WRITE_ASS(config,  "llu",  attr->config);
+
+	WRITE_ASS(sample_period, "llu", attr->sample_period);
+	WRITE_ASS(sample_type,   "llu", attr->sample_type);
+	WRITE_ASS(read_format,   "llu", attr->read_format);
+
+	WRITE_ASS(disabled,       "d", attr->disabled);
+	WRITE_ASS(inherit,        "d", attr->inherit);
+	WRITE_ASS(pinned,         "d", attr->pinned);
+	WRITE_ASS(exclusive,      "d", attr->exclusive);
+	WRITE_ASS(exclude_user,   "d", attr->exclude_user);
+	WRITE_ASS(exclude_kernel, "d", attr->exclude_kernel);
+	WRITE_ASS(exclude_hv,     "d", attr->exclude_hv);
+	WRITE_ASS(exclude_idle,   "d", attr->exclude_idle);
+	WRITE_ASS(mmap,           "d", attr->mmap);
+	WRITE_ASS(comm,           "d", attr->comm);
+	WRITE_ASS(freq,           "d", attr->freq);
+	WRITE_ASS(inherit_stat,   "d", attr->inherit_stat);
+	WRITE_ASS(enable_on_exec, "d", attr->enable_on_exec);
+	WRITE_ASS(task,           "d", attr->task);
+	WRITE_ASS(watermask,      "d", attr->watermark);
+	WRITE_ASS(precise_ip,     "d", attr->precise_ip);
+	WRITE_ASS(mmap_data,      "d", attr->mmap_data);
+	WRITE_ASS(sample_id_all,  "d", attr->sample_id_all);
+	WRITE_ASS(exclude_host,   "d", attr->exclude_host);
+	WRITE_ASS(exclude_guest,  "d", attr->exclude_guest);
+	WRITE_ASS(exclude_callchain_kernel, "d",
+		  attr->exclude_callchain_kernel);
+	WRITE_ASS(exclude_callchain_user, "d",
+		  attr->exclude_callchain_user);
+
+	WRITE_ASS(wakeup_events, PRIu32, attr->wakeup_events);
+
+	WRITE_ASS(bp_type, PRIu32, attr->bp_type);
+
+	WRITE_ASS(config1, "llu", attr->config1);
+	WRITE_ASS(config2, "llu", attr->config2);
+
+	WRITE_ASS(branch_sample_type, "llu", attr->branch_sample_type);
+	WRITE_ASS(sample_regs_user,   "llu", attr->sample_regs_user);
+	WRITE_ASS(sample_stack_user,  PRIu32, attr->sample_stack_user);
+
+	fclose(file);
+	return 0;
+}
+
+int test_attr__open(struct perf_event_attr *attr,
+		    pid_t pid, int cpu, int group_fd,
+		    unsigned long flags)
+{
+	int fd;
+
+	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
+		     group_fd, flags);
+
+	if (store_event(fd, attr, pid, cpu, group_fd, flags))
+		die("test attr FAILED");
+
+	return fd;
+}
diff --git a/tools/perf/util/test-attr.py b/tools/perf/util/test-attr.py
new file mode 100644
index 0000000..55d538c
--- /dev/null
+++ b/tools/perf/util/test-attr.py
@@ -0,0 +1,272 @@
+#! /usr/bin/python
+
+import os
+import sys
+import glob
+import optparse
+import tempfile
+import logging
+import shutil
+import ConfigParser
+
+class Fail(Exception):
+    def __init__(self, test, msg):
+        self.msg = msg
+        self.test = test
+    def getMsg(self):
+        return 'Test \'%s\' - %s' % (self.test.path, self.msg)
+
+class Unsup(Exception):
+    def __init__(self, test):
+        self.test = test
+    def getMsg(self):
+        return 'Test \'%s\'' % self.test.path
+
+class Event(dict):
+    terms = [
+        'flags',
+        'type',
+        'size',
+        'config',
+        'sample_period',
+        'sample_type',
+        'read_format',
+        'disabled',
+        'inherit',
+        'pinned',
+        'exclusive',
+        'exclude_user',
+        'exclude_kernel',
+        'exclude_hv',
+        'exclude_idle',
+        'mmap',
+        'comm',
+        'freq',
+        'inherit_stat',
+        'enable_on_exec',
+        'task',
+        'watermask',
+        'precise_ip',
+        'mmap_data',
+        'sample_id_all',
+        'exclude_host',
+        'exclude_guest',
+        'exclude_callchain_kernel',
+        'exclude_callchain_user',
+        'wakeup_events',
+        'bp_type',
+        'config1',
+        'config2',
+        'branch_sample_type',
+        'sample_regs_user',
+        'sample_stack_user',
+    ]
+
+    def add(self, data):
+        for key, val in data:
+            log.debug("      %s = %s" % (key, val))
+            self[key] = val
+
+    def __init__(self, data, base):
+        log.debug("    Event");
+        self.add(base)
+        self.add(data)
+
+    def compare_data(self, a, b):
+        if (a == b):
+            return True
+        elif (a == '*'):
+            return True
+        return False
+
+    def equal(self, other):
+        for t in Event.terms:
+            log.debug("      [%s] %s %s" % (t, self[t], other[t]));
+            if not self.has_key(t) or not other.has_key(t):
+                return False
+            if not self.compare_data(self[t], other[t]):
+                return False
+        return True
+
+class Test(object):
+    def __init__(self, path, options):
+        parser = ConfigParser.SafeConfigParser()
+        parser.read(path)
+
+        log.info("running test '%s'" % path)
+
+        self.path     = path
+        self.test_dir = options.test_dir
+        self.perf     = options.perf
+        self.command  = parser.get('config', 'command')
+        self.args     = parser.get('config', 'args')
+
+        try:
+            self.ret  = parser.get('config', 'ret')
+        except:
+            self.ret  = 0
+
+        self.expect   = {}
+        self.result   = {}
+        log.debug("  loading expected events");
+        self.load_events(path, self.expect)
+
+    def is_event(self, name):
+        if name.find("event") == -1:
+            return False
+        else:
+            return True
+
+    def load_events(self, path, events):
+        parser_event = ConfigParser.SafeConfigParser()
+        parser_event.read(path)
+
+        for section in filter(self.is_event, parser_event.sections()):
+
+            parser_items = parser_event.items(section);
+            base_items   = {}
+
+            if (':' in section):
+                base = section[section.index(':') + 1:]
+                parser_base = ConfigParser.SafeConfigParser()
+                parser_base.read(self.test_dir + '/' + base)
+                base_items = parser_base.items('event')
+
+            e = Event(parser_items, base_items)
+            events[ e['fd'] ] = e
+
+    def run_cmd(self, tempdir):
+        cmd = "PERF_TEST_ATTR=%s %s %s -o %s/perf.data %s" % (tempdir, self.perf, self.command, tempdir, self.args)
+        ret = os.WEXITSTATUS(os.system(cmd))
+
+        log.debug("  running '%s' ret %d " % (cmd, ret))
+
+        if ret != int(self.ret):
+            raise Unsup(self)
+
+    def compare(self):
+        match = {}
+
+        # For each expected event find all matching
+        # events in result. Fail if there's not any.
+        for exp_fd, exp_event in self.expect.items():
+            exp_fd_list = []
+            log.debug("  matching expected event fd %s" % exp_fd)
+            for res_fd, res_event in self.result.items():
+                log.debug("    result event fd %s" % res_fd)
+                if (exp_event.equal(res_event)):
+                    log.debug("      ok");
+                    exp_fd_list.append(res_fd)
+                else:
+                    log.debug("      fail");
+
+            log.debug("  fd %s matches fds %s" % (exp_fd, str(exp_fd_list)))
+            # we did not any matching event - fail
+            if not exp_fd_list:
+                raise Fail(self, 'match failure');
+
+            match[exp_fd] = exp_fd_list
+
+        # For each defined group in the expected events
+        # check we match the same group in the result.
+        for exp_fd, exp_event in self.expect.items():
+            exp_group_fd = exp_event['group_fd'];
+            if exp_group_fd == '-1':
+                continue;
+
+            for res_fd in match[exp_fd]:
+                res_group_fd = self.result[res_fd]['group_fd']
+                if res_group_fd not in match[exp_group_fd]:
+                    raise Fail(self, 'group failure')
+
+                log.debug("  result [fd %s group_fd %s] matches expected [fd %s group_fd %s]" %
+                         (res_fd, res_group_fd, exp_fd, exp_group_fd))
+
+        log.debug("  matched")
+
+    def run(self):
+        tempdir = tempfile.mkdtemp();
+
+        # run the test script
+        self.run_cmd(tempdir);
+
+        # load events expectation for the test
+        log.debug("  loading result events");
+        for f in glob.glob(tempdir + '/event*'):
+            self.load_events(f, self.result);
+
+        # do the expectation - results matching
+        self.compare()
+
+        # cleanup
+        shutil.rmtree(tempdir)
+
+
+def run_tests(options):
+    for f in glob.glob(options.test_dir + '/' + options.test):
+        try:
+            Test(f, options).run()
+        except Unsup, obj:
+            print "unsupp  %s" % obj.getMsg();
+
+def setup_log(verbose):
+    global log
+    level = logging.CRITICAL
+
+    if verbose == 1:
+        level = logging.INFO
+    if verbose >= 2:
+        level = logging.DEBUG
+
+    log = logging.getLogger('test')
+    log.setLevel(level)
+    ch  = logging.StreamHandler()
+    ch.setLevel(level)
+    formatter = logging.Formatter('%(message)s')
+    ch.setFormatter(formatter)
+    log.addHandler(ch)
+
+USAGE = '''%s [OPTIONS]
+  -d dir  # tests dir
+  -p path # perf binary
+  -t test # single test
+  -v      # verbose level
+''' % sys.argv[0]
+
+def main():
+    parser = optparse.OptionParser(usage=USAGE)
+
+    parser.add_option("-t", "--test",
+                      action="store", type="string", dest="test")
+    parser.add_option("-d", "--test-dir",
+                      action="store", type="string", dest="test_dir")
+    parser.add_option("-p", "--perf",
+                      action="store", type="string", dest="perf")
+    parser.add_option("-v", "--verbose",
+                      action="count", dest="verbose")
+
+    options, args = parser.parse_args()
+    if args:
+        parser.error('FAILED wrong arguments %s' %  ' '.join(args))
+        return -1
+
+    setup_log(options.verbose)
+
+    if not options.test_dir:
+        print 'FAILED no -d option specified'
+        sys.exit(-1)
+
+    if not options.test:
+        options.test = 'test*'
+
+    try:
+        run_tests(options)
+
+    except Fail, obj:
+        print "FAILED %s" % obj.getMsg();
+        sys.exit(-1)
+
+    sys.exit(0)
+
+if __name__ == '__main__':
+    main()
-- 
1.7.11.4

