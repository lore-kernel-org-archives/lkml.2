Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab2KNGnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:43:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43248 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2KNGn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:43:29 -0500
Date: Tue, 13 Nov 2012 22:40:44 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-52502bf201a85b5b51a384037a002d0b39093df0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20121031145247.GB1027@krava.brq.redhat.com>
References: <20121031145247.GB1027@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Add framework for automated perf_event_attr tests
Git-Commit-ID: 52502bf201a85b5b51a384037a002d0b39093df0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:40:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52502bf201a85b5b51a384037a002d0b39093df0
Gitweb:     http://git.kernel.org/tip/52502bf201a85b5b51a384037a002d0b39093df0
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 31 Oct 2012 15:52:47 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 31 Oct 2012 16:20:58 -0200

perf tests: Add framework for automated perf_event_attr tests

The idea is run perf session with kidnapping sys_perf_event_open
function. For each sys_perf_event_open call we store the perf_event_attr
data to the file to be checked later against what we expect.

You can run this by:
  $ python ./tests/attr.py -d ./tests/attr/ -p ./perf -v

v2 changes:
  - preserve errno value in the hook

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20121031145247.GB1027@krava.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |    1 +
 tools/perf/perf.c        |    2 +
 tools/perf/perf.h        |   16 ++-
 tools/perf/tests/attr.c  |  140 +++++++++++++++++++++
 tools/perf/tests/attr.py |  313 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 470 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2d3427f..1da87a3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -430,6 +430,7 @@ LIB_OBJS += $(OUTPUT)arch/common.o
 
 LIB_OBJS += $(OUTPUT)tests/parse-events.o
 LIB_OBJS += $(OUTPUT)tests/dso-data.o
+LIB_OBJS += $(OUTPUT)tests/attr.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index e968373..a0ae290 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -484,6 +484,8 @@ int main(int argc, const char **argv)
 	}
 	cmd = argv[0];
 
+	test_attr__init();
+
 	/*
 	 * We use PATH to find perf commands, but we prepend some higher
 	 * precedence paths: the "--exec-path" option, the PERF_EXEC_PATH
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 469fbf2..0047264 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -174,13 +174,25 @@ static inline unsigned long long rdclock(void)
 	(void) (&_min1 == &_min2);		\
 	_min1 < _min2 ? _min1 : _min2; })
 
+extern bool test_attr__enabled;
+void test_attr__init(void);
+void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
+		     int fd, int group_fd, unsigned long flags);
+
 static inline int
 sys_perf_event_open(struct perf_event_attr *attr,
 		      pid_t pid, int cpu, int group_fd,
 		      unsigned long flags)
 {
-	return syscall(__NR_perf_event_open, attr, pid, cpu,
-		       group_fd, flags);
+	int fd;
+
+	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
+		     group_fd, flags);
+
+	if (unlikely(test_attr__enabled))
+		test_attr__open(attr, pid, cpu, fd, group_fd, flags);
+
+	return fd;
 }
 
 #define MAX_COUNTERS			256
diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
new file mode 100644
index 0000000..55e9a87
--- /dev/null
+++ b/tools/perf/tests/attr.c
@@ -0,0 +1,140 @@
+
+/*
+ * The struct perf_event_attr test support.
+ *
+ * This test is embedded inside into perf directly and is governed
+ * by the PERF_TEST_ATTR environment variable and hook inside
+ * sys_perf_event_open function.
+ *
+ * The general idea is to store 'struct perf_event_attr' details for
+ * each event created within single perf command. Each event details
+ * are stored into separate text file. Once perf command is finished
+ * these files can be checked for values we expect for command.
+ *
+ * Besides 'struct perf_event_attr' values we also store 'fd' and
+ * 'group_fd' values to allow checking for groups created.
+ *
+ * This all is triggered by setting PERF_TEST_ATTR environment variable.
+ * It must contain name of existing directory with access and write
+ * permissions. All the event text files are stored there.
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <inttypes.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
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
+		fclose(file);						\
+		return -1;						\
+	}								\
+									\
+} while (0)
+
+static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
+		       int fd, int group_fd, unsigned long flags)
+{
+	FILE *file;
+	char path[PATH_MAX];
+
+	snprintf(path, PATH_MAX, "%s/event-%d-%llu-%d", dir,
+		 attr->type, attr->config, fd);
+
+	file = fopen(path, "w+");
+	if (!file) {
+		perror("test attr - failed to open event file");
+		return -1;
+	}
+
+	if (fprintf(file, "[event-%d-%llu-%d]\n",
+		    attr->type, attr->config, fd) < 0) {
+		perror("test attr - failed to write event file");
+		fclose(file);
+		return -1;
+	}
+
+	/* syscall arguments */
+	WRITE_ASS(fd,       "d", fd);
+	WRITE_ASS(group_fd, "d", group_fd);
+	WRITE_ASS(cpu,      "d", cpu);
+	WRITE_ASS(pid,      "d", pid);
+	WRITE_ASS(flags,   "lu", flags);
+
+	/* struct perf_event_attr */
+	WRITE_ASS(type,   PRIu32,  attr->type);
+	WRITE_ASS(size,   PRIu32,  attr->size);
+	WRITE_ASS(config,  "llu",  attr->config);
+	WRITE_ASS(sample_period, "llu", attr->sample_period);
+	WRITE_ASS(sample_type,   "llu", attr->sample_type);
+	WRITE_ASS(read_format,   "llu", attr->read_format);
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
+	WRITE_ASS(wakeup_events, PRIu32, attr->wakeup_events);
+	WRITE_ASS(bp_type, PRIu32, attr->bp_type);
+	WRITE_ASS(config1, "llu", attr->config1);
+	WRITE_ASS(config2, "llu", attr->config2);
+	WRITE_ASS(branch_sample_type, "llu", attr->branch_sample_type);
+	WRITE_ASS(sample_regs_user,   "llu", attr->sample_regs_user);
+	WRITE_ASS(sample_stack_user,  PRIu32, attr->sample_stack_user);
+	WRITE_ASS(optional, "d", 0);
+
+	fclose(file);
+	return 0;
+}
+
+void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
+		     int fd, int group_fd, unsigned long flags)
+{
+	int errno_saved = errno;
+
+	if (store_event(attr, pid, cpu, fd, group_fd, flags))
+		die("test attr FAILED");
+
+	errno = errno_saved;
+}
diff --git a/tools/perf/tests/attr.py b/tools/perf/tests/attr.py
new file mode 100644
index 0000000..e98c726
--- /dev/null
+++ b/tools/perf/tests/attr.py
@@ -0,0 +1,313 @@
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
+        return '\'%s\' - %s' % (self.test.path, self.msg)
+
+class Unsup(Exception):
+    def __init__(self, test):
+        self.test = test
+    def getMsg(self):
+        return '\'%s\'' % self.test.path
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
+    def __init__(self, name, data, base):
+        log.info("    Event %s" % name);
+        self.name  = name;
+        self.group = ''
+        self.add(base)
+        self.add(data)
+
+    def compare_data(self, a, b):
+        a_list = a.split('|')
+        b_list = b.split('|')
+
+        for a_item in a_list:
+            for b_item in b_list:
+                if (a_item == b_item):
+                    return True
+                elif (a_item == '*') or (b_item == '*'):
+                    return True
+
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
+    def is_optional(self):
+        if self['optional'] == '1':
+            return True
+        else:
+            return False
+
+class Test(object):
+    def __init__(self, path, options):
+        parser = ConfigParser.SafeConfigParser()
+        parser.read(path)
+
+        log.warning("running '%s'" % path)
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
+        log.info("  loading expected events");
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
+            e = Event(section, parser_items, base_items)
+            events[section] = e
+
+    def run_cmd(self, tempdir):
+        cmd = "PERF_TEST_ATTR=%s %s %s -o %s/perf.data %s" % (tempdir,
+              self.perf, self.command, tempdir, self.args)
+        ret = os.WEXITSTATUS(os.system(cmd))
+
+        log.info("  running '%s' ret %d " % (cmd, ret))
+
+        if ret != int(self.ret):
+            raise Unsup(self)
+
+    def compare(self, expect, result):
+        match = {}
+
+        log.info("  compare");
+
+        # For each expected event find all matching
+        # events in result. Fail if there's not any.
+        for exp_name, exp_event in expect.items():
+            exp_list = []
+            log.debug("    matching [%s]" % exp_name)
+            for res_name, res_event in result.items():
+                log.debug("      to [%s]" % res_name)
+                if (exp_event.equal(res_event)):
+                    exp_list.append(res_name)
+                    log.debug("    ->OK")
+                else:
+                    log.debug("    ->FAIL");
+
+            log.info("    match: [%s] optional(%d) matches %s" %
+                      (exp_name, exp_event.is_optional(), str(exp_list)))
+
+            # we did not any matching event - fail
+            if (not exp_list) and (not exp_event.is_optional()):
+                raise Fail(self, 'match failure');
+
+            match[exp_name] = exp_list
+
+        # For each defined group in the expected events
+        # check we match the same group in the result.
+        for exp_name, exp_event in expect.items():
+            group = exp_event.group
+
+            if (group == ''):
+                continue
+
+            # XXX group matching does not account for
+            # optional events as above matching does
+            for res_name in match[exp_name]:
+                res_group = result[res_name].group
+                if res_group not in match[group]:
+                    raise Fail(self, 'group failure')
+
+                log.info("    group: [%s] matches group leader %s" %
+                         (exp_name, str(match[group])))
+
+        log.info("  matched")
+
+    def resolve_groups(self, events):
+        for name, event in events.items():
+            group_fd = event['group_fd'];
+            if group_fd == '-1':
+                continue;
+
+            for iname, ievent in events.items():
+                if (ievent['fd'] == group_fd):
+                    event.group = iname
+                    log.debug('[%s] has group leader [%s]' % (name, iname))
+                    break;
+
+    def run(self):
+        tempdir = tempfile.mkdtemp();
+
+        # run the test script
+        self.run_cmd(tempdir);
+
+        # load events expectation for the test
+        log.info("  loading result events");
+        for f in glob.glob(tempdir + '/event*'):
+            self.load_events(f, self.result);
+
+        # resolve group_fd to event names
+        self.resolve_groups(self.expect);
+        self.resolve_groups(self.result);
+
+        # do the expectation - results matching - both ways
+        self.compare(self.expect, self.result)
+        self.compare(self.result, self.expect)
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
+            log.warning("unsupp  %s" % obj.getMsg())
+
+def setup_log(verbose):
+    global log
+    level = logging.CRITICAL
+
+    if verbose == 1:
+        level = logging.WARNING
+    if verbose == 2:
+        level = logging.INFO
+    if verbose >= 3:
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
