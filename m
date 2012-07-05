Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab2GEIX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 04:23:28 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46099 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab2GEIXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 04:23:23 -0400
MIME-Version: 1.0
Date: Thu, 5 Jul 2012 16:23:20 +0800
Message-ID: <CACV3sbLSzPoYYFJky=sFpca4L2gKdoOoEySn+mVHh1aphQLkyw@mail.gmail.com>
Subject: [PATCH] perf: add /proc/perf_events file for dump perf events info
From: Jovi Zhang <bookjovi@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d043c08d644e11b04c410dcb3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d043c08d644e11b04c410dcb3
Content-Type: text/plain; charset=UTF-8

Hi,

I'm looking for a way to watch all perf event in linux machine, so how
about below patch?
any comments is welcome!


>From 91fbcca37a2c9979083f4b9a6fa9c1875fc2886f Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Fri, 6 Jul 2012 00:05:40 +0800
Subject: [PATCH] perf: add /proc/perf_events file for dump perf events info

This new /proc/perf_events file is used for real time dump all
perf events info in whole system wide machine, this patch also add
a new field perf_entry in struct perf_event, for connect to
global list perf_events_list.

$./perf record -e mem:0xc09b7020 -g -a -d
$cat /proc/perf_events

1:
pmu: tracepoint
state: ACTIVE
attach_state: ATTACH_CONTEXT ATTACH_GROUP
oncpu: 0
cpu: 0
count: 71
id: 18
attr.type: TRACEPOINT
attr.config: 927
attr.sample_type: IP TID TIME CPU RAW
attr.bp_type: EMPTY
attr.bp_addr: 0x0
attr.bp_len: 0
attr flag: disabled(1) inherit(1) pinned(0) exclusive(0)
exclude_user(0) exclude_kernel(0) exclude_hv(0) exclude_idle(0)
mmap(1) comm(1) freq(0) inherit_stat(0) enable_on_exec(0) task(0)
watermark(0) precise_ip(0) mmap_data(0) sample_id_all(1)
exclude_host(0) exclude_guest(1)

2:
pmu: tracepoint
state: ACTIVE
attach_state: ATTACH_CONTEXT ATTACH_GROUP
oncpu: 1
cpu: 1
count: 178
id: 19
attr.type: TRACEPOINT
attr.config: 927
attr.sample_type: IP TID TIME CPU RAW
attr.bp_type: EMPTY
attr.bp_addr: 0x0
attr.bp_len: 0
attr flag: disabled(1) inherit(1) pinned(0) exclusive(0)
exclude_user(0) exclude_kernel(0) exclude_hv(0) exclude_idle(0)
mmap(1) comm(1) freq(0) inherit_stat(0) enable_on_exec(0) task(0)
watermark(0) precise_ip(0) mmap_data(0) sample_id_all(1)
exclude_host(0) exclude_guest(1)

...

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 include/linux/perf_event.h       |    1 +
 kernel/events/Makefile           |    1 +
 kernel/events/core.c             |   14 +++
 kernel/events/proc_perf_events.c |  204 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 220 insertions(+)
 create mode 100644 kernel/events/proc_perf_events.c

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 45db49f..7129558 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -871,6 +871,7 @@ struct perf_event {
  struct list_head group_entry;
  struct list_head event_entry;
  struct list_head sibling_list;
+ struct list_head perf_entry; /* used for connect with all perf_event*/
  struct hlist_node hlist_entry;
  int nr_siblings;
  int group_flags;
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 103f5d1..8b34070 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -6,4 +6,5 @@ obj-y := core.o ring_buffer.o callchain.o

 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_UPROBES) += uprobes.o
+obj-$(CONFIG_PROC_FS) += proc_perf_events.o

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d7d71d6..55766d0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -147,6 +147,10 @@ static LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
 static struct srcu_struct pmus_srcu;

+LIST_HEAD(perf_events_list);
+DEFINE_MUTEX(perf_events_lock);
+
+
 /*
  * perf event paranoia level:
  *  -1 - not paranoid at all
@@ -2897,6 +2901,10 @@ static void free_event(struct perf_event *event)
  if (event->ctx)
  put_ctx(event->ctx);

+ mutex_lock(&perf_events_lock);
+ list_del_rcu(&event->perf_entry);
+ mutex_unlock(&perf_events_lock);
+
  call_rcu(&event->rcu_head, free_event_rcu);
 }

@@ -5916,6 +5924,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
  INIT_LIST_HEAD(&event->event_entry);
  INIT_LIST_HEAD(&event->sibling_list);
  INIT_LIST_HEAD(&event->rb_entry);
+ INIT_LIST_HEAD(&event->perf_entry);

  init_waitqueue_head(&event->waitq);
  init_irq_work(&event->pending, perf_pending_event);
@@ -6013,6 +6022,10 @@ done:
  }
  }

+ mutex_lock(&perf_events_lock);
+ list_add_tail_rcu(&event->perf_entry, &perf_events_list);
+ mutex_unlock(&perf_events_lock);
+
  return event;
 }

@@ -7220,3 +7233,4 @@ struct cgroup_subsys perf_subsys = {
  .attach = perf_cgroup_attach,
 };
 #endif /* CONFIG_CGROUP_PERF */
+
diff --git a/kernel/events/proc_perf_events.c b/kernel/events/proc_perf_events.c
new file mode 100644
index 0000000..5c2d56c
--- /dev/null
+++ b/kernel/events/proc_perf_events.c
@@ -0,0 +1,204 @@
+/*
+ * linux/kerenl/events/proc_perf_events.c
+ *
+ * Dump information for all perf_event
+ *
+ * Created by: Jovi Zhang (bookjovi@gmail.com)
+ *
+ */
+
+#include <linux/perf_event.h>
+#include <linux/hw_breakpoint.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+extern struct list_head perf_events_list;
+extern struct mutex perf_events_lock;
+
+static const char *perf_state_name(enum perf_event_active_state state)
+{
+ const char *name;
+
+ switch (state) {
+ case PERF_EVENT_STATE_ERROR:
+ name = "ERROR";
+ break;
+ case PERF_EVENT_STATE_OFF:
+ name = "OFF";
+ break;
+ case PERF_EVENT_STATE_INACTIVE:
+ name = "INACTIVE";
+ break;
+ case PERF_EVENT_STATE_ACTIVE:
+ name = "ACTIVE";
+ break;
+ default:
+ name = "NULL";
+ }
+
+ return name;
+}
+
+static void perf_attach_state_show(struct seq_file *m,
+   unsigned int attach_state)
+{
+ seq_printf(m, "attach_state:\t\t");
+
+ if (attach_state & PERF_ATTACH_CONTEXT)
+ seq_printf(m, "ATTACH_CONTEXT ");
+ if (attach_state & PERF_ATTACH_GROUP)
+ seq_printf(m, "ATTACH_GROUP ");
+ if (attach_state & PERF_ATTACH_TASK)
+ seq_printf(m, " ATTACH_TASK ");
+
+ seq_putc(m, '\n');
+}
+
+static void perf_attr_sample_type_show(struct seq_file *m, __u64 sample_type)
+{
+ int i, valid = 0;
+
+ static char *sample_type_name[] = {
+ "IP",
+ "TID",
+ "TIME",
+ "ADDR",
+ "READ",
+ "CALLCHAIN",
+ "ID",
+ "CPU",
+ "PERIOD",
+ "STREAM_ID",
+ "RAW",
+ "BRANCH_STACK"
+ };
+
+ seq_printf(m, "attr.sample_type:\t");
+
+ for (i = 0; i < ARRAY_SIZE(sample_type_name); i++) {
+ if (sample_type & (1UL << i)) {
+ seq_printf(m, "%s ", sample_type_name[i]);
+ valid = 1;
+ }
+ }
+
+ if (!valid)
+ seq_printf(m, "NULL");
+
+ seq_putc(m, '\n');
+}
+
+static void perf_event_bp_show(struct seq_file *m,
+       __u32 bp_type, __u32 bp_addr, __u32 bp_len)
+{
+ char *name;
+
+ seq_printf(m, "attr.bp_type:\t\t");
+ switch (bp_type) {
+ case HW_BREAKPOINT_EMPTY:
+ name = "EMPTY";
+ break;
+ case HW_BREAKPOINT_R:
+ name = "R";
+ break;
+ case HW_BREAKPOINT_W:
+ name = "W";
+ break;
+ case HW_BREAKPOINT_RW:
+ name = "RW";
+ break;
+ case HW_BREAKPOINT_X:
+ name = "X";
+ break;
+ case HW_BREAKPOINT_INVALID:
+ name = "INVALID";
+ break;
+ default:
+ name = "NULL";
+ }
+ seq_printf(m, "%s\n", name);
+
+ seq_printf(m, "attr.bp_addr:\t\t0x%x\n", bp_addr);
+ seq_printf(m, "attr.bp_len:\t\t%d\n", bp_len);
+}
+
+static void perf_event_attr_show(struct seq_file *m,
+ struct perf_event_attr *attr)
+{
+ static const char * const type_name[] = {
+ "HARDWARE",
+ "SOFTWARE",
+ "TRACEPOINT",
+ "HW_CACHE",
+ "RAW",
+ "BREAKPOINT"
+ };
+
+ seq_printf(m, "attr.type:\t\t%s\n", type_name[attr->type]);
+ seq_printf(m, "attr.config:\t\t%llu\n", attr->config);
+ perf_attr_sample_type_show(m, attr->sample_type);
+ perf_event_bp_show(m, attr->bp_type, attr->bp_addr, attr->bp_len);
+ seq_printf(m, "attr flag:\t\tdisabled(%d) inherit(%d) pinned(%d) "
+ "exclusive(%d) exclude_user(%d) exclude_kernel(%d) "
+ "exclude_hv(%d) exclude_idle(%d) mmap(%d) comm(%d) "
+ "freq(%d) inherit_stat(%d) enable_on_exec(%d) task(%d) "
+ "watermark(%d) precise_ip(%d) mmap_data(%d) "
+ "sample_id_all(%d) exclude_host(%d) exclude_guest(%d)",
+ attr->disabled, attr->inherit, attr->pinned,
+ attr->exclusive, attr->exclude_user,
+ attr->exclude_kernel, attr->exclude_hv,
+ attr->exclude_idle, attr->mmap, attr->comm, attr->freq,
+ attr->inherit_stat, attr->enable_on_exec, attr->task,
+ attr->watermark, attr->precise_ip, attr->mmap_data,
+ attr->sample_id_all, attr->exclude_host,
+ attr->exclude_guest);
+ seq_putc(m, '\n');
+}
+
+static int perf_events_proc_show(struct seq_file *m, void *v)
+{
+ struct perf_event *event;
+ int i = 0;
+
+ mutex_lock(&perf_events_lock);
+ list_for_each_entry(event, &perf_events_list, perf_entry) {
+ i++;
+ seq_printf(m, "%d:\n", i);
+ seq_printf(m, "pmu:\t\t\t%s\n",
+ event->pmu ? event->pmu->name : "NULL");
+ seq_printf(m, "state:\t\t\t%s\n",
+ perf_state_name(event->state));
+ perf_attach_state_show(m, event->attach_state);
+ seq_printf(m, "oncpu:\t\t\t%d\n", event->oncpu);
+ seq_printf(m, "cpu:\t\t\t%d\n", event->cpu);
+ seq_printf(m, "count:\t\t\t%llu\n",
+ local64_read(&event->count));
+ seq_printf(m, "id:\t\t\t%llu\n", event->id);
+ perf_event_attr_show(m, &event->attr);
+
+ seq_putc(m, '\n');
+ }
+ mutex_unlock(&perf_events_lock);
+
+ return 0;
+}
+
+static int perf_events_proc_open(struct inode *inode, struct file *file)
+{
+ return single_open(file, perf_events_proc_show, NULL);
+}
+
+static const struct file_operations perf_events_proc_fops = {
+ .open           = perf_events_proc_open,
+ .read           = seq_read,
+ .llseek         = seq_lseek,
+ .release        = single_release,
+};
+
+static int __init proc_perf_events_init(void)
+{
+ proc_create("perf_events", 0444, NULL, &perf_events_proc_fops);
+ return 0;
+}
+
+device_initcall(proc_perf_events_init);
--
1.7.9.7

--f46d043c08d644e11b04c410dcb3
Content-Type: application/octet-stream; 
	name="0001-perf-add-proc-perf_events-file-for-dump-perf-events-.patch"
Content-Disposition: attachment; 
	filename="0001-perf-add-proc-perf_events-file-for-dump-perf-events-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h49kdqyx0

RnJvbSA5MWZiY2NhMzdhMmM5OTc5MDgzZjRiOWE2ZmE5YzE4NzVmYzI4ODZmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb3ZpIFpoYW5nIDxib29ram92aUBnbWFpbC5jb20+CkRhdGU6
IEZyaSwgNiBKdWwgMjAxMiAwMDowNTo0MCArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIHBlcmY6IGFk
ZCAvcHJvYy9wZXJmX2V2ZW50cyBmaWxlIGZvciBkdW1wIHBlcmYgZXZlbnRzIGluZm8KClRoaXMg
bmV3IC9wcm9jL3BlcmZfZXZlbnRzIGZpbGUgaXMgdXNlZCBmb3IgcmVhbCB0aW1lIGR1bXAgYWxs
CnBlcmYgZXZlbnRzIGluZm8gaW4gd2hvbGUgc3lzdGVtIHdpZGUgbWFjaGluZSwgdGhpcyBwYXRj
aCBhbHNvIGFkZAphIG5ldyBmaWVsZCBwZXJmX2VudHJ5IGluIHN0cnVjdCBwZXJmX2V2ZW50LCBm
b3IgY29ubmVjdCB0bwpnbG9iYWwgbGlzdCBwZXJmX2V2ZW50c19saXN0LgoKJC4vcGVyZiByZWNv
cmQgLWUgbWVtOjB4YzA5YjcwMjAgLWcgLWEgLWQKJGNhdCAvcHJvYy9wZXJmX2V2ZW50cwoKMToK
cG11OgkJCXRyYWNlcG9pbnQKc3RhdGU6CQkJQUNUSVZFCmF0dGFjaF9zdGF0ZToJCUFUVEFDSF9D
T05URVhUIEFUVEFDSF9HUk9VUApvbmNwdToJCQkwCmNwdToJCQkwCmNvdW50OgkJCTcxCmlkOgkJ
CTE4CmF0dHIudHlwZToJCVRSQUNFUE9JTlQKYXR0ci5jb25maWc6CQk5MjcKYXR0ci5zYW1wbGVf
dHlwZToJSVAgVElEIFRJTUUgQ1BVIFJBVwphdHRyLmJwX3R5cGU6CQlFTVBUWQphdHRyLmJwX2Fk
ZHI6CQkweDAKYXR0ci5icF9sZW46CQkwCmF0dHIgZmxhZzoJCWRpc2FibGVkKDEpIGluaGVyaXQo
MSkgcGlubmVkKDApIGV4Y2x1c2l2ZSgwKSBleGNsdWRlX3VzZXIoMCkgZXhjbHVkZV9rZXJuZWwo
MCkgZXhjbHVkZV9odigwKSBleGNsdWRlX2lkbGUoMCkgbW1hcCgxKSBjb21tKDEpIGZyZXEoMCkg
aW5oZXJpdF9zdGF0KDApIGVuYWJsZV9vbl9leGVjKDApIHRhc2soMCkgd2F0ZXJtYXJrKDApIHBy
ZWNpc2VfaXAoMCkgbW1hcF9kYXRhKDApIHNhbXBsZV9pZF9hbGwoMSkgZXhjbHVkZV9ob3N0KDAp
IGV4Y2x1ZGVfZ3Vlc3QoMSkKCjI6CnBtdToJCQl0cmFjZXBvaW50CnN0YXRlOgkJCUFDVElWRQph
dHRhY2hfc3RhdGU6CQlBVFRBQ0hfQ09OVEVYVCBBVFRBQ0hfR1JPVVAKb25jcHU6CQkJMQpjcHU6
CQkJMQpjb3VudDoJCQkxNzgKaWQ6CQkJMTkKYXR0ci50eXBlOgkJVFJBQ0VQT0lOVAphdHRyLmNv
bmZpZzoJCTkyNwphdHRyLnNhbXBsZV90eXBlOglJUCBUSUQgVElNRSBDUFUgUkFXCmF0dHIuYnBf
dHlwZToJCUVNUFRZCmF0dHIuYnBfYWRkcjoJCTB4MAphdHRyLmJwX2xlbjoJCTAKYXR0ciBmbGFn
OgkJZGlzYWJsZWQoMSkgaW5oZXJpdCgxKSBwaW5uZWQoMCkgZXhjbHVzaXZlKDApIGV4Y2x1ZGVf
dXNlcigwKSBleGNsdWRlX2tlcm5lbCgwKSBleGNsdWRlX2h2KDApIGV4Y2x1ZGVfaWRsZSgwKSBt
bWFwKDEpIGNvbW0oMSkgZnJlcSgwKSBpbmhlcml0X3N0YXQoMCkgZW5hYmxlX29uX2V4ZWMoMCkg
dGFzaygwKSB3YXRlcm1hcmsoMCkgcHJlY2lzZV9pcCgwKSBtbWFwX2RhdGEoMCkgc2FtcGxlX2lk
X2FsbCgxKSBleGNsdWRlX2hvc3QoMCkgZXhjbHVkZV9ndWVzdCgxKQoKLi4uCgpTaWduZWQtb2Zm
LWJ5OiBKb3ZpIFpoYW5nIDxib29ram92aUBnbWFpbC5jb20+Ci0tLQogaW5jbHVkZS9saW51eC9w
ZXJmX2V2ZW50LmggICAgICAgfCAgICAxICsKIGtlcm5lbC9ldmVudHMvTWFrZWZpbGUgICAgICAg
ICAgIHwgICAgMSArCiBrZXJuZWwvZXZlbnRzL2NvcmUuYyAgICAgICAgICAgICB8ICAgMTQgKysr
CiBrZXJuZWwvZXZlbnRzL3Byb2NfcGVyZl9ldmVudHMuYyB8ICAyMDQgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysKIDQgZmlsZXMgY2hhbmdlZCwgMjIwIGluc2VydGlvbnMo
KykKIGNyZWF0ZSBtb2RlIDEwMDY0NCBrZXJuZWwvZXZlbnRzL3Byb2NfcGVyZl9ldmVudHMuYwoK
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcGVyZl9ldmVudC5oIGIvaW5jbHVkZS9saW51eC9w
ZXJmX2V2ZW50LmgKaW5kZXggNDVkYjQ5Zi4uNzEyOTU1OCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9s
aW51eC9wZXJmX2V2ZW50LmgKKysrIGIvaW5jbHVkZS9saW51eC9wZXJmX2V2ZW50LmgKQEAgLTg3
MSw2ICs4NzEsNyBAQCBzdHJ1Y3QgcGVyZl9ldmVudCB7CiAJc3RydWN0IGxpc3RfaGVhZAkJZ3Jv
dXBfZW50cnk7CiAJc3RydWN0IGxpc3RfaGVhZAkJZXZlbnRfZW50cnk7CiAJc3RydWN0IGxpc3Rf
aGVhZAkJc2libGluZ19saXN0OworCXN0cnVjdCBsaXN0X2hlYWQJCXBlcmZfZW50cnk7IC8qIHVz
ZWQgZm9yIGNvbm5lY3Qgd2l0aCBhbGwgcGVyZl9ldmVudCovCiAJc3RydWN0IGhsaXN0X25vZGUJ
CWhsaXN0X2VudHJ5OwogCWludAkJCQlucl9zaWJsaW5nczsKIAlpbnQJCQkJZ3JvdXBfZmxhZ3M7
CmRpZmYgLS1naXQgYS9rZXJuZWwvZXZlbnRzL01ha2VmaWxlIGIva2VybmVsL2V2ZW50cy9NYWtl
ZmlsZQppbmRleCAxMDNmNWQxLi44YjM0MDcwIDEwMDY0NAotLS0gYS9rZXJuZWwvZXZlbnRzL01h
a2VmaWxlCisrKyBiL2tlcm5lbC9ldmVudHMvTWFrZWZpbGUKQEAgLTYsNCArNiw1IEBAIG9iai15
IDo9IGNvcmUubyByaW5nX2J1ZmZlci5vIGNhbGxjaGFpbi5vCiAKIG9iai0kKENPTkZJR19IQVZF
X0hXX0JSRUFLUE9JTlQpICs9IGh3X2JyZWFrcG9pbnQubwogb2JqLSQoQ09ORklHX1VQUk9CRVMp
ICs9IHVwcm9iZXMubworb2JqLSQoQ09ORklHX1BST0NfRlMpICs9IHByb2NfcGVyZl9ldmVudHMu
bwogCmRpZmYgLS1naXQgYS9rZXJuZWwvZXZlbnRzL2NvcmUuYyBiL2tlcm5lbC9ldmVudHMvY29y
ZS5jCmluZGV4IGQ3ZDcxZDYuLjU1NzY2ZDAgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9ldmVudHMvY29y
ZS5jCisrKyBiL2tlcm5lbC9ldmVudHMvY29yZS5jCkBAIC0xNDcsNiArMTQ3LDEwIEBAIHN0YXRp
YyBMSVNUX0hFQUQocG11cyk7CiBzdGF0aWMgREVGSU5FX01VVEVYKHBtdXNfbG9jayk7CiBzdGF0
aWMgc3RydWN0IHNyY3Vfc3RydWN0IHBtdXNfc3JjdTsKIAorTElTVF9IRUFEKHBlcmZfZXZlbnRz
X2xpc3QpOworREVGSU5FX01VVEVYKHBlcmZfZXZlbnRzX2xvY2spOworCisKIC8qCiAgKiBwZXJm
IGV2ZW50IHBhcmFub2lhIGxldmVsOgogICogIC0xIC0gbm90IHBhcmFub2lkIGF0IGFsbApAQCAt
Mjg5Nyw2ICsyOTAxLDEwIEBAIHN0YXRpYyB2b2lkIGZyZWVfZXZlbnQoc3RydWN0IHBlcmZfZXZl
bnQgKmV2ZW50KQogCWlmIChldmVudC0+Y3R4KQogCQlwdXRfY3R4KGV2ZW50LT5jdHgpOwogCisJ
bXV0ZXhfbG9jaygmcGVyZl9ldmVudHNfbG9jayk7CisJbGlzdF9kZWxfcmN1KCZldmVudC0+cGVy
Zl9lbnRyeSk7CisJbXV0ZXhfdW5sb2NrKCZwZXJmX2V2ZW50c19sb2NrKTsKKwogCWNhbGxfcmN1
KCZldmVudC0+cmN1X2hlYWQsIGZyZWVfZXZlbnRfcmN1KTsKIH0KIApAQCAtNTkxNiw2ICs1OTI0
LDcgQEAgcGVyZl9ldmVudF9hbGxvYyhzdHJ1Y3QgcGVyZl9ldmVudF9hdHRyICphdHRyLCBpbnQg
Y3B1LAogCUlOSVRfTElTVF9IRUFEKCZldmVudC0+ZXZlbnRfZW50cnkpOwogCUlOSVRfTElTVF9I
RUFEKCZldmVudC0+c2libGluZ19saXN0KTsKIAlJTklUX0xJU1RfSEVBRCgmZXZlbnQtPnJiX2Vu
dHJ5KTsKKwlJTklUX0xJU1RfSEVBRCgmZXZlbnQtPnBlcmZfZW50cnkpOwogCiAJaW5pdF93YWl0
cXVldWVfaGVhZCgmZXZlbnQtPndhaXRxKTsKIAlpbml0X2lycV93b3JrKCZldmVudC0+cGVuZGlu
ZywgcGVyZl9wZW5kaW5nX2V2ZW50KTsKQEAgLTYwMTMsNiArNjAyMiwxMCBAQCBkb25lOgogCQl9
CiAJfQogCisJbXV0ZXhfbG9jaygmcGVyZl9ldmVudHNfbG9jayk7CisJbGlzdF9hZGRfdGFpbF9y
Y3UoJmV2ZW50LT5wZXJmX2VudHJ5LCAmcGVyZl9ldmVudHNfbGlzdCk7CisJbXV0ZXhfdW5sb2Nr
KCZwZXJmX2V2ZW50c19sb2NrKTsKKwogCXJldHVybiBldmVudDsKIH0KIApAQCAtNzIyMCwzICs3
MjMzLDQgQEAgc3RydWN0IGNncm91cF9zdWJzeXMgcGVyZl9zdWJzeXMgPSB7CiAJLmF0dGFjaAkJ
PSBwZXJmX2Nncm91cF9hdHRhY2gsCiB9OwogI2VuZGlmIC8qIENPTkZJR19DR1JPVVBfUEVSRiAq
LworCmRpZmYgLS1naXQgYS9rZXJuZWwvZXZlbnRzL3Byb2NfcGVyZl9ldmVudHMuYyBiL2tlcm5l
bC9ldmVudHMvcHJvY19wZXJmX2V2ZW50cy5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAw
MDAwMDAuLjVjMmQ1NmMKLS0tIC9kZXYvbnVsbAorKysgYi9rZXJuZWwvZXZlbnRzL3Byb2NfcGVy
Zl9ldmVudHMuYwpAQCAtMCwwICsxLDIwNCBAQAorLyoKKyAqCWxpbnV4L2tlcmVubC9ldmVudHMv
cHJvY19wZXJmX2V2ZW50cy5jCisgKgorICoJRHVtcCBpbmZvcm1hdGlvbiBmb3IgYWxsIHBlcmZf
ZXZlbnQKKyAqCisgKglDcmVhdGVkIGJ5OiBKb3ZpIFpoYW5nIChib29ram92aUBnbWFpbC5jb20p
CisgKgorICovCisKKyNpbmNsdWRlIDxsaW51eC9wZXJmX2V2ZW50Lmg+CisjaW5jbHVkZSA8bGlu
dXgvaHdfYnJlYWtwb2ludC5oPgorI2luY2x1ZGUgPGxpbnV4L3Byb2NfZnMuaD4KKyNpbmNsdWRl
IDxsaW51eC9zZXFfZmlsZS5oPgorCitleHRlcm4gc3RydWN0IGxpc3RfaGVhZCBwZXJmX2V2ZW50
c19saXN0OworZXh0ZXJuIHN0cnVjdCBtdXRleCBwZXJmX2V2ZW50c19sb2NrOworCitzdGF0aWMg
Y29uc3QgY2hhciAqcGVyZl9zdGF0ZV9uYW1lKGVudW0gcGVyZl9ldmVudF9hY3RpdmVfc3RhdGUg
c3RhdGUpCit7CisJY29uc3QgY2hhciAqbmFtZTsKKworCXN3aXRjaCAoc3RhdGUpIHsKKwljYXNl
IFBFUkZfRVZFTlRfU1RBVEVfRVJST1I6CisJCW5hbWUgPSAiRVJST1IiOworCQlicmVhazsKKwlj
YXNlIFBFUkZfRVZFTlRfU1RBVEVfT0ZGOgorCQluYW1lID0gIk9GRiI7CisJCWJyZWFrOworCWNh
c2UgUEVSRl9FVkVOVF9TVEFURV9JTkFDVElWRToKKwkJbmFtZSA9ICJJTkFDVElWRSI7CisJCWJy
ZWFrOworCWNhc2UgUEVSRl9FVkVOVF9TVEFURV9BQ1RJVkU6CisJCW5hbWUgPSAiQUNUSVZFIjsK
KwkJYnJlYWs7CisJZGVmYXVsdDoKKwkJbmFtZSA9ICJOVUxMIjsKKwl9CisKKwlyZXR1cm4gbmFt
ZTsKK30KKworc3RhdGljIHZvaWQgcGVyZl9hdHRhY2hfc3RhdGVfc2hvdyhzdHJ1Y3Qgc2VxX2Zp
bGUgKm0sCisJCQkJICAgdW5zaWduZWQgaW50IGF0dGFjaF9zdGF0ZSkKK3sKKwlzZXFfcHJpbnRm
KG0sICJhdHRhY2hfc3RhdGU6XHRcdCIpOworCisJaWYgKGF0dGFjaF9zdGF0ZSAmIFBFUkZfQVRU
QUNIX0NPTlRFWFQpCisJCXNlcV9wcmludGYobSwgIkFUVEFDSF9DT05URVhUICIpOworCWlmIChh
dHRhY2hfc3RhdGUgJiBQRVJGX0FUVEFDSF9HUk9VUCkKKwkJc2VxX3ByaW50ZihtLCAiQVRUQUNI
X0dST1VQICIpOworCWlmIChhdHRhY2hfc3RhdGUgJiBQRVJGX0FUVEFDSF9UQVNLKQorCQlzZXFf
cHJpbnRmKG0sICIgQVRUQUNIX1RBU0sgIik7CisKKwlzZXFfcHV0YyhtLCAnXG4nKTsKK30KKwor
c3RhdGljIHZvaWQgcGVyZl9hdHRyX3NhbXBsZV90eXBlX3Nob3coc3RydWN0IHNlcV9maWxlICpt
LCBfX3U2NCBzYW1wbGVfdHlwZSkKK3sKKwlpbnQgaSwgdmFsaWQgPSAwOworCisJc3RhdGljIGNo
YXIgKnNhbXBsZV90eXBlX25hbWVbXSA9IHsKKwkJIklQIiwKKwkJIlRJRCIsCisJCSJUSU1FIiwK
KwkJIkFERFIiLAorCQkiUkVBRCIsCisJCSJDQUxMQ0hBSU4iLAorCQkiSUQiLAorCQkiQ1BVIiwK
KwkJIlBFUklPRCIsCisJCSJTVFJFQU1fSUQiLAorCQkiUkFXIiwKKwkJIkJSQU5DSF9TVEFDSyIK
Kwl9OworCisJc2VxX3ByaW50ZihtLCAiYXR0ci5zYW1wbGVfdHlwZTpcdCIpOworCisJZm9yIChp
ID0gMDsgaSA8IEFSUkFZX1NJWkUoc2FtcGxlX3R5cGVfbmFtZSk7IGkrKykgeworCQlpZiAoc2Ft
cGxlX3R5cGUgJiAoMVVMIDw8IGkpKSB7CisJCQlzZXFfcHJpbnRmKG0sICIlcyAiLCBzYW1wbGVf
dHlwZV9uYW1lW2ldKTsKKwkJCXZhbGlkID0gMTsKKwkJfQorCX0KKworCWlmICghdmFsaWQpCisJ
CXNlcV9wcmludGYobSwgIk5VTEwiKTsKKworCXNlcV9wdXRjKG0sICdcbicpOworfQorCitzdGF0
aWMgdm9pZCBwZXJmX2V2ZW50X2JwX3Nob3coc3RydWN0IHNlcV9maWxlICptLAorCQkJICAgICAg
IF9fdTMyIGJwX3R5cGUsIF9fdTMyIGJwX2FkZHIsIF9fdTMyIGJwX2xlbikKK3sKKwljaGFyICpu
YW1lOworCisJc2VxX3ByaW50ZihtLCAiYXR0ci5icF90eXBlOlx0XHQiKTsKKwlzd2l0Y2ggKGJw
X3R5cGUpIHsKKwljYXNlIEhXX0JSRUFLUE9JTlRfRU1QVFk6CisJCW5hbWUgPSAiRU1QVFkiOwor
CQlicmVhazsKKwljYXNlIEhXX0JSRUFLUE9JTlRfUjoKKwkJbmFtZSA9ICJSIjsKKwkJYnJlYWs7
CisJY2FzZSBIV19CUkVBS1BPSU5UX1c6CisJCW5hbWUgPSAiVyI7CisJCWJyZWFrOworCWNhc2Ug
SFdfQlJFQUtQT0lOVF9SVzoKKwkJbmFtZSA9ICJSVyI7CisJCWJyZWFrOworCWNhc2UgSFdfQlJF
QUtQT0lOVF9YOgorCQluYW1lID0gIlgiOworCQlicmVhazsKKwljYXNlIEhXX0JSRUFLUE9JTlRf
SU5WQUxJRDoKKwkJbmFtZSA9ICJJTlZBTElEIjsKKwkJYnJlYWs7CisJZGVmYXVsdDoKKwkJbmFt
ZSA9ICJOVUxMIjsKKwl9CisJc2VxX3ByaW50ZihtLCAiJXNcbiIsIG5hbWUpOworCisJc2VxX3By
aW50ZihtLCAiYXR0ci5icF9hZGRyOlx0XHQweCV4XG4iLCBicF9hZGRyKTsKKwlzZXFfcHJpbnRm
KG0sICJhdHRyLmJwX2xlbjpcdFx0JWRcbiIsIGJwX2xlbik7Cit9CisKK3N0YXRpYyB2b2lkIHBl
cmZfZXZlbnRfYXR0cl9zaG93KHN0cnVjdCBzZXFfZmlsZSAqbSwKKwkJCQkgc3RydWN0IHBlcmZf
ZXZlbnRfYXR0ciAqYXR0cikKK3sKKwlzdGF0aWMgY29uc3QgY2hhciAqIGNvbnN0IHR5cGVfbmFt
ZVtdID0geworCQkiSEFSRFdBUkUiLAorCQkiU09GVFdBUkUiLAorCQkiVFJBQ0VQT0lOVCIsCisJ
CSJIV19DQUNIRSIsCisJCSJSQVciLAorCQkiQlJFQUtQT0lOVCIKKwl9OworCisJc2VxX3ByaW50
ZihtLCAiYXR0ci50eXBlOlx0XHQlc1xuIiwgdHlwZV9uYW1lW2F0dHItPnR5cGVdKTsKKwlzZXFf
cHJpbnRmKG0sICJhdHRyLmNvbmZpZzpcdFx0JWxsdVxuIiwgYXR0ci0+Y29uZmlnKTsKKwlwZXJm
X2F0dHJfc2FtcGxlX3R5cGVfc2hvdyhtLCBhdHRyLT5zYW1wbGVfdHlwZSk7CisJcGVyZl9ldmVu
dF9icF9zaG93KG0sIGF0dHItPmJwX3R5cGUsIGF0dHItPmJwX2FkZHIsIGF0dHItPmJwX2xlbik7
CisJc2VxX3ByaW50ZihtLCAiYXR0ciBmbGFnOlx0XHRkaXNhYmxlZCglZCkgaW5oZXJpdCglZCkg
cGlubmVkKCVkKSAiCisJCQkiZXhjbHVzaXZlKCVkKSBleGNsdWRlX3VzZXIoJWQpIGV4Y2x1ZGVf
a2VybmVsKCVkKSAiCisJCQkiZXhjbHVkZV9odiglZCkgZXhjbHVkZV9pZGxlKCVkKSBtbWFwKCVk
KSBjb21tKCVkKSAiCisJCQkiZnJlcSglZCkgaW5oZXJpdF9zdGF0KCVkKSBlbmFibGVfb25fZXhl
YyglZCkgdGFzayglZCkgIgorCQkJIndhdGVybWFyayglZCkgcHJlY2lzZV9pcCglZCkgbW1hcF9k
YXRhKCVkKSAiCisJCQkic2FtcGxlX2lkX2FsbCglZCkgZXhjbHVkZV9ob3N0KCVkKSBleGNsdWRl
X2d1ZXN0KCVkKSIsCisJCQlhdHRyLT5kaXNhYmxlZCwgYXR0ci0+aW5oZXJpdCwgYXR0ci0+cGlu
bmVkLAorCQkJYXR0ci0+ZXhjbHVzaXZlLCBhdHRyLT5leGNsdWRlX3VzZXIsCisJCQlhdHRyLT5l
eGNsdWRlX2tlcm5lbCwgYXR0ci0+ZXhjbHVkZV9odiwKKwkJCWF0dHItPmV4Y2x1ZGVfaWRsZSwg
YXR0ci0+bW1hcCwgYXR0ci0+Y29tbSwgYXR0ci0+ZnJlcSwKKwkJCWF0dHItPmluaGVyaXRfc3Rh
dCwgYXR0ci0+ZW5hYmxlX29uX2V4ZWMsIGF0dHItPnRhc2ssCisJCQlhdHRyLT53YXRlcm1hcmss
IGF0dHItPnByZWNpc2VfaXAsIGF0dHItPm1tYXBfZGF0YSwKKwkJCWF0dHItPnNhbXBsZV9pZF9h
bGwsIGF0dHItPmV4Y2x1ZGVfaG9zdCwKKwkJCWF0dHItPmV4Y2x1ZGVfZ3Vlc3QpOworCXNlcV9w
dXRjKG0sICdcbicpOworfQorCitzdGF0aWMgaW50IHBlcmZfZXZlbnRzX3Byb2Nfc2hvdyhzdHJ1
Y3Qgc2VxX2ZpbGUgKm0sIHZvaWQgKnYpCit7CisJc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50Owor
CWludCBpID0gMDsKKworCW11dGV4X2xvY2soJnBlcmZfZXZlbnRzX2xvY2spOworCWxpc3RfZm9y
X2VhY2hfZW50cnkoZXZlbnQsICZwZXJmX2V2ZW50c19saXN0LCBwZXJmX2VudHJ5KSB7CisJCWkr
KzsKKwkJc2VxX3ByaW50ZihtLCAiJWQ6XG4iLCBpKTsKKwkJc2VxX3ByaW50ZihtLCAicG11Olx0
XHRcdCVzXG4iLAorCQkJCWV2ZW50LT5wbXUgPyBldmVudC0+cG11LT5uYW1lIDogIk5VTEwiKTsK
KwkJc2VxX3ByaW50ZihtLCAic3RhdGU6XHRcdFx0JXNcbiIsCisJCQkJcGVyZl9zdGF0ZV9uYW1l
KGV2ZW50LT5zdGF0ZSkpOworCQlwZXJmX2F0dGFjaF9zdGF0ZV9zaG93KG0sIGV2ZW50LT5hdHRh
Y2hfc3RhdGUpOworCQlzZXFfcHJpbnRmKG0sICJvbmNwdTpcdFx0XHQlZFxuIiwgZXZlbnQtPm9u
Y3B1KTsKKwkJc2VxX3ByaW50ZihtLCAiY3B1Olx0XHRcdCVkXG4iLCBldmVudC0+Y3B1KTsKKwkJ
c2VxX3ByaW50ZihtLCAiY291bnQ6XHRcdFx0JWxsdVxuIiwKKwkJCQlsb2NhbDY0X3JlYWQoJmV2
ZW50LT5jb3VudCkpOworCQlzZXFfcHJpbnRmKG0sICJpZDpcdFx0XHQlbGx1XG4iLCBldmVudC0+
aWQpOworCQlwZXJmX2V2ZW50X2F0dHJfc2hvdyhtLCAmZXZlbnQtPmF0dHIpOworCisJCXNlcV9w
dXRjKG0sICdcbicpOworCX0KKwltdXRleF91bmxvY2soJnBlcmZfZXZlbnRzX2xvY2spOworCisJ
cmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgcGVyZl9ldmVudHNfcHJvY19vcGVuKHN0cnVjdCBp
bm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQoreworCXJldHVybiBzaW5nbGVfb3Blbihm
aWxlLCBwZXJmX2V2ZW50c19wcm9jX3Nob3csIE5VTEwpOworfQorCitzdGF0aWMgY29uc3Qgc3Ry
dWN0IGZpbGVfb3BlcmF0aW9ucyBwZXJmX2V2ZW50c19wcm9jX2ZvcHMgPSB7CisJLm9wZW4gICAg
ICAgICAgID0gcGVyZl9ldmVudHNfcHJvY19vcGVuLAorCS5yZWFkICAgICAgICAgICA9IHNlcV9y
ZWFkLAorCS5sbHNlZWsgICAgICAgICA9IHNlcV9sc2VlaywKKwkucmVsZWFzZSAgICAgICAgPSBz
aW5nbGVfcmVsZWFzZSwKK307CisKK3N0YXRpYyBpbnQgX19pbml0IHByb2NfcGVyZl9ldmVudHNf
aW5pdCh2b2lkKQoreworCXByb2NfY3JlYXRlKCJwZXJmX2V2ZW50cyIsIDA0NDQsIE5VTEwsICZw
ZXJmX2V2ZW50c19wcm9jX2ZvcHMpOworCXJldHVybiAwOworfQorCitkZXZpY2VfaW5pdGNhbGwo
cHJvY19wZXJmX2V2ZW50c19pbml0KTsKLS0gCjEuNy45LjcKCg==
--f46d043c08d644e11b04c410dcb3--
