Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab2GFC0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 22:26:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53480 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab2GFC0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 22:26:03 -0400
MIME-Version: 1.0
In-Reply-To: <1341496440.19870.69.camel@laptop>
References: <CACV3sbLSzPoYYFJky=sFpca4L2gKdoOoEySn+mVHh1aphQLkyw@mail.gmail.com>
	<1341476877.7709.0.camel@twins>
	<CACV3sb+aadXJYu7_JUedCodgQmF8d1q7OxSVoz=vwfc+Ow_caA@mail.gmail.com>
	<CACV3sbLJpv2KSSkrRRDVuJ6xtJOSwCKaJfhO1wMF6DgAU9eCBw@mail.gmail.com>
	<1341493725.19870.46.camel@laptop>
	<CACV3sb+rixP3HZ2=dJoe7x+9Rc5amRKu7dyj_4mcaZajwH2MSA@mail.gmail.com>
	<1341496440.19870.69.camel@laptop>
Date: Fri, 6 Jul 2012 10:26:01 +0800
Message-ID: <CACV3sbKS2gJ4TytqZjx1LP-ZF0wYqS=QoaTFnq+X72EWWpucEg@mail.gmail.com>
Subject: Re: [PATCH] perf: add /proc/perf_events file for dump perf events info
From: Jovi Zhang <bookjovi@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@redhat.com>
Content-Type: multipart/mixed; boundary=e0cb4e6ffbf73808ec04c41ffc8f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e0cb4e6ffbf73808ec04c41ffc8f
Content-Type: text/plain; charset=UTF-8

Hi peter,

Very thanks for your comments!

>> sorry, I will try to explain more.
>>
>> One problem I faced is about hw_breakpoint.
>> As you known, hw_breakpoint use limit debug register in most architecture,
>> In multi-user environment, sometime user cannot set hw_breakpoint because
>> other user already occupy hw_breakpoint slots. currently, there don't
>> have a way to know
>> how many hw_breakpint perf event already is used in system, so that's
>> why I thinking
>> we might need a way to get perf event in systerm wide, with visable output.
>
> Hrmm,. so this seems pretty specific to the horror of hw_breakpoint. And
> yes those are unfortunate and weird.
>
> But how would you use this proc file? Would you go read it
> programmatically or just look at it as a user to figure out why stuff
> doesn't work?

Currently I using eye to figure out what happening in system using
this /proc/perf_events,
but this file should be parsed programmatically when if need.

>
>> Also this method is not only used for hw_breakpoint, others perf event
>> might have similar problem,
>> even other perf event don't have limit number, but it can make use of
>> this /proc/perf_events
>
> They have a limit alright, but we can round-robin them to hide this fact
> (unless you tell it not to).
>
>> Active perf events is cpu consumer at most time, at this point of
>> view, system administrator also can use this
>> /proc/perf_events to detect is there have any perf events is consuming cpu.
>
> I doubt you can see which is consuming cycles, but you can see if
> there's any in use.
>
>> A method to detect perf event leak? of couse our perf subsystem is
>> very stable right now, ingnore this :)
>
> There's alway bugs ;-)
>
> The problem I have with the patch is the global nature of it.. but if
> something like this is require I guess I can live with it. But it might
> be the current proposal is exposing too much information, I would
> certainly not mark it readable for the entire world either.
>
In this patch version 1, I outputed some field info which might not
need very heavily,
so I removed oncpu(overlaped with cpu field) and attr flag in next
version patch, now it
seems more clearly than before, only output key point field info of perf event.

How about below version 2 patch(attached again)?


>From 8fd37b246dcd4f50cb32e5250db5a0aaccc398cc Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Fri, 6 Jul 2012 18:01:03 +0800
Subject: [PATCH] perf: add /proc/perf_events file for dump perf events info

kernel should provide some information to user to get know how many
perf event is in use, especially some perf events already occupied
limited resource(like hw_breakpoint).

This patch add a /proc/perf_events file to dump perf events info
in system wide, with some key field of perf_event, include pmu name,
state, attach_state, cpu, count, id, and some field of attr.

See demo:

[root@jovi perf]# cat /proc/kallsyms |grep linux_proc_banner
c09b7020 R linux_proc_banner
[root@jovi perf]# ./perf record -e mem:0xc09b7020 -g -a -d
...
[root@jovi proc]# cat /proc/version
...

[root@jovi proc]# cat /proc/perf_events
1:
pmu:                        breakpoint
state:                        ACTIVE
attach_state:             ATTACH_CONTEXT ATTACH_GROUP
cpu:                          0
count:                       0
id:                            13
attr.type:                   BREAKPOINT
attr.config:                 0
attr.sample_type:       IP TID TIME ADDR CALLCHAIN CPU PERIOD
attr.bp_type:              RW
attr.bp_addr:              0xc09b7020
attr.bp_len:                4

2:
pmu:                         breakpoint
state:                        ACTIVE
attach_state:             ATTACH_CONTEXT ATTACH_GROUP
cpu:                          1
count:                        0
id:                             14
attr.type:                    BREAKPOINT
attr.config:                  0
attr.sample_type:        IP TID TIME ADDR CALLCHAIN CPU PERIOD
attr.bp_type:               RW
attr.bp_addr:               0xc09b7020
attr.bp_len:                 4

3:
...

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 include/linux/perf_event.h       |    1 +
 kernel/events/Makefile           |    1 +
 kernel/events/core.c             |   14 +++
 kernel/events/proc_perf_events.c |  188 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 204 insertions(+)
 create mode 100644 kernel/events/proc_perf_events.c

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 45db49f..67d9e7d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -871,6 +871,7 @@ struct perf_event {
 	struct list_head		group_entry;
 	struct list_head		event_entry;
 	struct list_head		sibling_list;
+	struct list_head		perf_entry;
 	struct hlist_node		hlist_entry;
 	int				nr_siblings;
 	int				group_flags;
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

+	mutex_lock(&perf_events_lock);
+	list_del_rcu(&event->perf_entry);
+	mutex_unlock(&perf_events_lock);
+
 	call_rcu(&event->rcu_head, free_event_rcu);
 }

@@ -5916,6 +5924,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
 	INIT_LIST_HEAD(&event->rb_entry);
+	INIT_LIST_HEAD(&event->perf_entry);

 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending, perf_pending_event);
@@ -6013,6 +6022,10 @@ done:
 		}
 	}

+	mutex_lock(&perf_events_lock);
+	list_add_tail_rcu(&event->perf_entry, &perf_events_list);
+	mutex_unlock(&perf_events_lock);
+
 	return event;
 }

@@ -7220,3 +7233,4 @@ struct cgroup_subsys perf_subsys = {
 	.attach		= perf_cgroup_attach,
 };
 #endif /* CONFIG_CGROUP_PERF */
+
diff --git a/kernel/events/proc_perf_events.c b/kernel/events/proc_perf_events.c
new file mode 100644
index 0000000..7079701
--- /dev/null
+++ b/kernel/events/proc_perf_events.c
@@ -0,0 +1,188 @@
+/*
+ *	linux/kerenl/events/proc_perf_events.c
+ *
+ *	Dump information for all perf_event
+ *
+ *	Created by: Jovi Zhang (bookjovi@gmail.com)
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
+	const char *name;
+
+	switch (state) {
+	case PERF_EVENT_STATE_ERROR:
+		name = "ERROR";
+		break;
+	case PERF_EVENT_STATE_OFF:
+		name = "OFF";
+		break;
+	case PERF_EVENT_STATE_INACTIVE:
+		name = "INACTIVE";
+		break;
+	case PERF_EVENT_STATE_ACTIVE:
+		name = "ACTIVE";
+		break;
+	default:
+		name = "NULL";
+	}
+
+	return name;
+}
+
+static void perf_attach_state_show(struct seq_file *m,
+				   unsigned int attach_state)
+{
+	seq_printf(m, "attach_state:\t\t");
+
+	if (attach_state & PERF_ATTACH_CONTEXT)
+		seq_printf(m, "ATTACH_CONTEXT ");
+	if (attach_state & PERF_ATTACH_GROUP)
+		seq_printf(m, "ATTACH_GROUP ");
+	if (attach_state & PERF_ATTACH_TASK)
+		seq_printf(m, " ATTACH_TASK ");
+
+	seq_putc(m, '\n');
+}
+
+static void perf_attr_sample_type_show(struct seq_file *m, __u64 sample_type)
+{
+	int i, valid = 0;
+
+	static char *sample_type_name[] = {
+		"IP",
+		"TID",
+		"TIME",
+		"ADDR",
+		"READ",
+		"CALLCHAIN",
+		"ID",
+		"CPU",
+		"PERIOD",
+		"STREAM_ID",
+		"RAW",
+		"BRANCH_STACK"
+	};
+
+	seq_printf(m, "attr.sample_type:\t");
+
+	for (i = 0; i < ARRAY_SIZE(sample_type_name); i++) {
+		if (sample_type & (1UL << i)) {
+			seq_printf(m, "%s ", sample_type_name[i]);
+			valid = 1;
+		}
+	}
+
+	if (!valid)
+		seq_printf(m, "NULL");
+
+	seq_putc(m, '\n');
+}
+
+static void perf_event_bp_show(struct seq_file *m,
+			       __u32 bp_type, __u32 bp_addr, __u32 bp_len)
+{
+	char *name;
+
+	seq_printf(m, "attr.bp_type:\t\t");
+	switch (bp_type) {
+	case HW_BREAKPOINT_EMPTY:
+		name = "EMPTY";
+		break;
+	case HW_BREAKPOINT_R:
+		name = "R";
+		break;
+	case HW_BREAKPOINT_W:
+		name = "W";
+		break;
+	case HW_BREAKPOINT_RW:
+		name = "RW";
+		break;
+	case HW_BREAKPOINT_X:
+		name = "X";
+		break;
+	case HW_BREAKPOINT_INVALID:
+		name = "INVALID";
+		break;
+	default:
+		name = "NULL";
+	}
+	seq_printf(m, "%s\n", name);
+
+	seq_printf(m, "attr.bp_addr:\t\t0x%x\n", bp_addr);
+	seq_printf(m, "attr.bp_len:\t\t%d\n", bp_len);
+}
+
+static void perf_event_attr_show(struct seq_file *m,
+				 struct perf_event_attr *attr)
+{
+	static const char * const type_name[] = {
+		"HARDWARE",
+		"SOFTWARE",
+		"TRACEPOINT",
+		"HW_CACHE",
+		"RAW",
+		"BREAKPOINT"
+	};
+
+	seq_printf(m, "attr.type:\t\t%s\n", type_name[attr->type]);
+	seq_printf(m, "attr.config:\t\t%llu\n", attr->config);
+	perf_attr_sample_type_show(m, attr->sample_type);
+	perf_event_bp_show(m, attr->bp_type, attr->bp_addr, attr->bp_len);
+}
+
+static int perf_events_proc_show(struct seq_file *m, void *v)
+{
+	struct perf_event *event;
+	int i = 0;
+
+	mutex_lock(&perf_events_lock);
+	list_for_each_entry(event, &perf_events_list, perf_entry) {
+		i++;
+		seq_printf(m, "%d:\n", i);
+		seq_printf(m, "pmu:\t\t\t%s\n",
+				event->pmu ? event->pmu->name : "NULL");
+		seq_printf(m, "state:\t\t\t%s\n",
+				perf_state_name(event->state));
+		perf_attach_state_show(m, event->attach_state);
+		seq_printf(m, "cpu:\t\t\t%d\n", event->cpu);
+		seq_printf(m, "count:\t\t\t%llu\n",
+				local64_read(&event->count));
+		seq_printf(m, "id:\t\t\t%llu\n", event->id);
+		perf_event_attr_show(m, &event->attr);
+
+		seq_putc(m, '\n');
+	}
+	mutex_unlock(&perf_events_lock);
+
+	return 0;
+}
+
+static int perf_events_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, perf_events_proc_show, NULL);
+}
+
+static const struct file_operations perf_events_proc_fops = {
+	.open           = perf_events_proc_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = single_release,
+};
+
+static int __init proc_perf_events_init(void)
+{
+	proc_create("perf_events", 0444, NULL, &perf_events_proc_fops);
+	return 0;
+}
+
+device_initcall(proc_perf_events_init);
-- 
1.7.9.7

--e0cb4e6ffbf73808ec04c41ffc8f
Content-Type: application/octet-stream; 
	name="0001-perf-add-proc-perf_events-file-for-dump-perf-events-.patch"
Content-Disposition: attachment; 
	filename="0001-perf-add-proc-perf_events-file-for-dump-perf-events-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h4an55uy0

RnJvbSA4ZmQzN2IyNDZkY2Q0ZjUwY2IzMmU1MjUwZGI1YTBhYWNjYzM5OGNjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb3ZpIFpoYW5nIDxib29ram92aUBnbWFpbC5jb20+CkRhdGU6
IEZyaSwgNiBKdWwgMjAxMiAxODowMTowMyArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIHBlcmY6IGFk
ZCAvcHJvYy9wZXJmX2V2ZW50cyBmaWxlIGZvciBkdW1wIHBlcmYgZXZlbnRzIGluZm8KCmtlcm5l
bCBzaG91bGQgcHJvdmlkZSBzb21lIGluZm9ybWF0aW9uIHRvIHVzZXIgdG8gZ2V0IGtub3cgaG93
IG1hbnkKcGVyZiBldmVudCBpcyBpbiB1c2UsIGVzcGVjaWFsbHkgc29tZSBwZXJmIGV2ZW50cyBh
bHJlYWR5IG9jY3VwaWVkCmxpbWl0ZWQgcmVzb3VyY2UobGlrZSBod19icmVha3BvaW50KS4KClRo
aXMgcGF0Y2ggYWRkIGEgL3Byb2MvcGVyZl9ldmVudHMgZmlsZSB0byBkdW1wIHBlcmYgZXZlbnRz
IGluZm8KaW4gc3lzdGVtIHdpZGUsIHdpdGggc29tZSBrZXkgZmllbGQgb2YgcGVyZl9ldmVudCwg
aW5jbHVkZSBwbXUgbmFtZSwKc3RhdGUsIGF0dGFjaF9zdGF0ZSwgY3B1LCBjb3VudCwgaWQsIGFu
ZCBzb21lIGZpZWxkIG9mIGF0dHIuCgpTZWUgZGVtbzoKCltyb290QGpvdmkgcGVyZl0jIGNhdCAv
cHJvYy9rYWxsc3ltcyB8Z3JlcCBsaW51eF9wcm9jX2Jhbm5lcgpjMDliNzAyMCBSIGxpbnV4X3By
b2NfYmFubmVyCltyb290QGpvdmkgcGVyZl0jIC4vcGVyZiByZWNvcmQgLWUgbWVtOjB4YzA5Yjcw
MjAgLWcgLWEgLWQKLi4uCltyb290QGpvdmkgcHJvY10jIGNhdCAvcHJvYy92ZXJzaW9uCi4uLgoK
W3Jvb3RAam92aSBwcm9jXSMgY2F0IC9wcm9jL3BlcmZfZXZlbnRzCjE6CnBtdTogICAgICAgICAg
ICAgICAgICAgIGJyZWFrcG9pbnQKc3RhdGU6ICAgICAgICAgICAgICAgICAgQUNUSVZFCmF0dGFj
aF9zdGF0ZTogICAgICAgICAgIEFUVEFDSF9DT05URVhUIEFUVEFDSF9HUk9VUApjcHU6ICAgICAg
ICAgICAgICAgICAgICAwCmNvdW50OiAgICAgICAgICAgICAgICAgIDAKaWQ6ICAgICAgICAgICAg
ICAgICAgICAgMTMKYXR0ci50eXBlOiAgICAgICAgICAgICAgQlJFQUtQT0lOVAphdHRyLmNvbmZp
ZzogICAgICAgICAgICAwCmF0dHIuc2FtcGxlX3R5cGU6ICAgICAgIElQIFRJRCBUSU1FIEFERFIg
Q0FMTENIQUlOIENQVSBQRVJJT0QKYXR0ci5icF90eXBlOiAgICAgICAgICAgUlcKYXR0ci5icF9h
ZGRyOiAgICAgICAgICAgMHhjMDliNzAyMAphdHRyLmJwX2xlbjogICAgICAgICAgICA0CgoyOgpw
bXU6ICAgICAgICAgICAgICAgICAgICBicmVha3BvaW50CnN0YXRlOiAgICAgICAgICAgICAgICAg
IEFDVElWRQphdHRhY2hfc3RhdGU6ICAgICAgICAgICBBVFRBQ0hfQ09OVEVYVCBBVFRBQ0hfR1JP
VVAKY3B1OiAgICAgICAgICAgICAgICAgICAgMQpjb3VudDogICAgICAgICAgICAgICAgICAwCmlk
OiAgICAgICAgICAgICAgICAgICAgIDE0CmF0dHIudHlwZTogICAgICAgICAgICAgIEJSRUFLUE9J
TlQKYXR0ci5jb25maWc6ICAgICAgICAgICAgMAphdHRyLnNhbXBsZV90eXBlOiAgICAgICBJUCBU
SUQgVElNRSBBRERSIENBTExDSEFJTiBDUFUgUEVSSU9ECmF0dHIuYnBfdHlwZTogICAgICAgICAg
IFJXCmF0dHIuYnBfYWRkcjogICAgICAgICAgIDB4YzA5YjcwMjAKYXR0ci5icF9sZW46ICAgICAg
ICAgICAgNAoKMzoKLi4uCgpTaWduZWQtb2ZmLWJ5OiBKb3ZpIFpoYW5nIDxib29ram92aUBnbWFp
bC5jb20+Ci0tLQogaW5jbHVkZS9saW51eC9wZXJmX2V2ZW50LmggICAgICAgfCAgICAxICsKIGtl
cm5lbC9ldmVudHMvTWFrZWZpbGUgICAgICAgICAgIHwgICAgMSArCiBrZXJuZWwvZXZlbnRzL2Nv
cmUuYyAgICAgICAgICAgICB8ICAgMTQgKysrCiBrZXJuZWwvZXZlbnRzL3Byb2NfcGVyZl9ldmVu
dHMuYyB8ICAxODggKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIDQgZmls
ZXMgY2hhbmdlZCwgMjA0IGluc2VydGlvbnMoKykKIGNyZWF0ZSBtb2RlIDEwMDY0NCBrZXJuZWwv
ZXZlbnRzL3Byb2NfcGVyZl9ldmVudHMuYwoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcGVy
Zl9ldmVudC5oIGIvaW5jbHVkZS9saW51eC9wZXJmX2V2ZW50LmgKaW5kZXggNDVkYjQ5Zi4uNjdk
OWU3ZCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9wZXJmX2V2ZW50LmgKKysrIGIvaW5jbHVk
ZS9saW51eC9wZXJmX2V2ZW50LmgKQEAgLTg3MSw2ICs4NzEsNyBAQCBzdHJ1Y3QgcGVyZl9ldmVu
dCB7CiAJc3RydWN0IGxpc3RfaGVhZAkJZ3JvdXBfZW50cnk7CiAJc3RydWN0IGxpc3RfaGVhZAkJ
ZXZlbnRfZW50cnk7CiAJc3RydWN0IGxpc3RfaGVhZAkJc2libGluZ19saXN0OworCXN0cnVjdCBs
aXN0X2hlYWQJCXBlcmZfZW50cnk7CiAJc3RydWN0IGhsaXN0X25vZGUJCWhsaXN0X2VudHJ5Owog
CWludAkJCQlucl9zaWJsaW5nczsKIAlpbnQJCQkJZ3JvdXBfZmxhZ3M7CmRpZmYgLS1naXQgYS9r
ZXJuZWwvZXZlbnRzL01ha2VmaWxlIGIva2VybmVsL2V2ZW50cy9NYWtlZmlsZQppbmRleCAxMDNm
NWQxLi44YjM0MDcwIDEwMDY0NAotLS0gYS9rZXJuZWwvZXZlbnRzL01ha2VmaWxlCisrKyBiL2tl
cm5lbC9ldmVudHMvTWFrZWZpbGUKQEAgLTYsNCArNiw1IEBAIG9iai15IDo9IGNvcmUubyByaW5n
X2J1ZmZlci5vIGNhbGxjaGFpbi5vCiAKIG9iai0kKENPTkZJR19IQVZFX0hXX0JSRUFLUE9JTlQp
ICs9IGh3X2JyZWFrcG9pbnQubwogb2JqLSQoQ09ORklHX1VQUk9CRVMpICs9IHVwcm9iZXMubwor
b2JqLSQoQ09ORklHX1BST0NfRlMpICs9IHByb2NfcGVyZl9ldmVudHMubwogCmRpZmYgLS1naXQg
YS9rZXJuZWwvZXZlbnRzL2NvcmUuYyBiL2tlcm5lbC9ldmVudHMvY29yZS5jCmluZGV4IGQ3ZDcx
ZDYuLjU1NzY2ZDAgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9ldmVudHMvY29yZS5jCisrKyBiL2tlcm5l
bC9ldmVudHMvY29yZS5jCkBAIC0xNDcsNiArMTQ3LDEwIEBAIHN0YXRpYyBMSVNUX0hFQUQocG11
cyk7CiBzdGF0aWMgREVGSU5FX01VVEVYKHBtdXNfbG9jayk7CiBzdGF0aWMgc3RydWN0IHNyY3Vf
c3RydWN0IHBtdXNfc3JjdTsKIAorTElTVF9IRUFEKHBlcmZfZXZlbnRzX2xpc3QpOworREVGSU5F
X01VVEVYKHBlcmZfZXZlbnRzX2xvY2spOworCisKIC8qCiAgKiBwZXJmIGV2ZW50IHBhcmFub2lh
IGxldmVsOgogICogIC0xIC0gbm90IHBhcmFub2lkIGF0IGFsbApAQCAtMjg5Nyw2ICsyOTAxLDEw
IEBAIHN0YXRpYyB2b2lkIGZyZWVfZXZlbnQoc3RydWN0IHBlcmZfZXZlbnQgKmV2ZW50KQogCWlm
IChldmVudC0+Y3R4KQogCQlwdXRfY3R4KGV2ZW50LT5jdHgpOwogCisJbXV0ZXhfbG9jaygmcGVy
Zl9ldmVudHNfbG9jayk7CisJbGlzdF9kZWxfcmN1KCZldmVudC0+cGVyZl9lbnRyeSk7CisJbXV0
ZXhfdW5sb2NrKCZwZXJmX2V2ZW50c19sb2NrKTsKKwogCWNhbGxfcmN1KCZldmVudC0+cmN1X2hl
YWQsIGZyZWVfZXZlbnRfcmN1KTsKIH0KIApAQCAtNTkxNiw2ICs1OTI0LDcgQEAgcGVyZl9ldmVu
dF9hbGxvYyhzdHJ1Y3QgcGVyZl9ldmVudF9hdHRyICphdHRyLCBpbnQgY3B1LAogCUlOSVRfTElT
VF9IRUFEKCZldmVudC0+ZXZlbnRfZW50cnkpOwogCUlOSVRfTElTVF9IRUFEKCZldmVudC0+c2li
bGluZ19saXN0KTsKIAlJTklUX0xJU1RfSEVBRCgmZXZlbnQtPnJiX2VudHJ5KTsKKwlJTklUX0xJ
U1RfSEVBRCgmZXZlbnQtPnBlcmZfZW50cnkpOwogCiAJaW5pdF93YWl0cXVldWVfaGVhZCgmZXZl
bnQtPndhaXRxKTsKIAlpbml0X2lycV93b3JrKCZldmVudC0+cGVuZGluZywgcGVyZl9wZW5kaW5n
X2V2ZW50KTsKQEAgLTYwMTMsNiArNjAyMiwxMCBAQCBkb25lOgogCQl9CiAJfQogCisJbXV0ZXhf
bG9jaygmcGVyZl9ldmVudHNfbG9jayk7CisJbGlzdF9hZGRfdGFpbF9yY3UoJmV2ZW50LT5wZXJm
X2VudHJ5LCAmcGVyZl9ldmVudHNfbGlzdCk7CisJbXV0ZXhfdW5sb2NrKCZwZXJmX2V2ZW50c19s
b2NrKTsKKwogCXJldHVybiBldmVudDsKIH0KIApAQCAtNzIyMCwzICs3MjMzLDQgQEAgc3RydWN0
IGNncm91cF9zdWJzeXMgcGVyZl9zdWJzeXMgPSB7CiAJLmF0dGFjaAkJPSBwZXJmX2Nncm91cF9h
dHRhY2gsCiB9OwogI2VuZGlmIC8qIENPTkZJR19DR1JPVVBfUEVSRiAqLworCmRpZmYgLS1naXQg
YS9rZXJuZWwvZXZlbnRzL3Byb2NfcGVyZl9ldmVudHMuYyBiL2tlcm5lbC9ldmVudHMvcHJvY19w
ZXJmX2V2ZW50cy5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLjcwNzk3MDEK
LS0tIC9kZXYvbnVsbAorKysgYi9rZXJuZWwvZXZlbnRzL3Byb2NfcGVyZl9ldmVudHMuYwpAQCAt
MCwwICsxLDE4OCBAQAorLyoKKyAqCWxpbnV4L2tlcmVubC9ldmVudHMvcHJvY19wZXJmX2V2ZW50
cy5jCisgKgorICoJRHVtcCBpbmZvcm1hdGlvbiBmb3IgYWxsIHBlcmZfZXZlbnQKKyAqCisgKglD
cmVhdGVkIGJ5OiBKb3ZpIFpoYW5nIChib29ram92aUBnbWFpbC5jb20pCisgKgorICovCisKKyNp
bmNsdWRlIDxsaW51eC9wZXJmX2V2ZW50Lmg+CisjaW5jbHVkZSA8bGludXgvaHdfYnJlYWtwb2lu
dC5oPgorI2luY2x1ZGUgPGxpbnV4L3Byb2NfZnMuaD4KKyNpbmNsdWRlIDxsaW51eC9zZXFfZmls
ZS5oPgorCitleHRlcm4gc3RydWN0IGxpc3RfaGVhZCBwZXJmX2V2ZW50c19saXN0OworZXh0ZXJu
IHN0cnVjdCBtdXRleCBwZXJmX2V2ZW50c19sb2NrOworCitzdGF0aWMgY29uc3QgY2hhciAqcGVy
Zl9zdGF0ZV9uYW1lKGVudW0gcGVyZl9ldmVudF9hY3RpdmVfc3RhdGUgc3RhdGUpCit7CisJY29u
c3QgY2hhciAqbmFtZTsKKworCXN3aXRjaCAoc3RhdGUpIHsKKwljYXNlIFBFUkZfRVZFTlRfU1RB
VEVfRVJST1I6CisJCW5hbWUgPSAiRVJST1IiOworCQlicmVhazsKKwljYXNlIFBFUkZfRVZFTlRf
U1RBVEVfT0ZGOgorCQluYW1lID0gIk9GRiI7CisJCWJyZWFrOworCWNhc2UgUEVSRl9FVkVOVF9T
VEFURV9JTkFDVElWRToKKwkJbmFtZSA9ICJJTkFDVElWRSI7CisJCWJyZWFrOworCWNhc2UgUEVS
Rl9FVkVOVF9TVEFURV9BQ1RJVkU6CisJCW5hbWUgPSAiQUNUSVZFIjsKKwkJYnJlYWs7CisJZGVm
YXVsdDoKKwkJbmFtZSA9ICJOVUxMIjsKKwl9CisKKwlyZXR1cm4gbmFtZTsKK30KKworc3RhdGlj
IHZvaWQgcGVyZl9hdHRhY2hfc3RhdGVfc2hvdyhzdHJ1Y3Qgc2VxX2ZpbGUgKm0sCisJCQkJICAg
dW5zaWduZWQgaW50IGF0dGFjaF9zdGF0ZSkKK3sKKwlzZXFfcHJpbnRmKG0sICJhdHRhY2hfc3Rh
dGU6XHRcdCIpOworCisJaWYgKGF0dGFjaF9zdGF0ZSAmIFBFUkZfQVRUQUNIX0NPTlRFWFQpCisJ
CXNlcV9wcmludGYobSwgIkFUVEFDSF9DT05URVhUICIpOworCWlmIChhdHRhY2hfc3RhdGUgJiBQ
RVJGX0FUVEFDSF9HUk9VUCkKKwkJc2VxX3ByaW50ZihtLCAiQVRUQUNIX0dST1VQICIpOworCWlm
IChhdHRhY2hfc3RhdGUgJiBQRVJGX0FUVEFDSF9UQVNLKQorCQlzZXFfcHJpbnRmKG0sICIgQVRU
QUNIX1RBU0sgIik7CisKKwlzZXFfcHV0YyhtLCAnXG4nKTsKK30KKworc3RhdGljIHZvaWQgcGVy
Zl9hdHRyX3NhbXBsZV90eXBlX3Nob3coc3RydWN0IHNlcV9maWxlICptLCBfX3U2NCBzYW1wbGVf
dHlwZSkKK3sKKwlpbnQgaSwgdmFsaWQgPSAwOworCisJc3RhdGljIGNoYXIgKnNhbXBsZV90eXBl
X25hbWVbXSA9IHsKKwkJIklQIiwKKwkJIlRJRCIsCisJCSJUSU1FIiwKKwkJIkFERFIiLAorCQki
UkVBRCIsCisJCSJDQUxMQ0hBSU4iLAorCQkiSUQiLAorCQkiQ1BVIiwKKwkJIlBFUklPRCIsCisJ
CSJTVFJFQU1fSUQiLAorCQkiUkFXIiwKKwkJIkJSQU5DSF9TVEFDSyIKKwl9OworCisJc2VxX3By
aW50ZihtLCAiYXR0ci5zYW1wbGVfdHlwZTpcdCIpOworCisJZm9yIChpID0gMDsgaSA8IEFSUkFZ
X1NJWkUoc2FtcGxlX3R5cGVfbmFtZSk7IGkrKykgeworCQlpZiAoc2FtcGxlX3R5cGUgJiAoMVVM
IDw8IGkpKSB7CisJCQlzZXFfcHJpbnRmKG0sICIlcyAiLCBzYW1wbGVfdHlwZV9uYW1lW2ldKTsK
KwkJCXZhbGlkID0gMTsKKwkJfQorCX0KKworCWlmICghdmFsaWQpCisJCXNlcV9wcmludGYobSwg
Ik5VTEwiKTsKKworCXNlcV9wdXRjKG0sICdcbicpOworfQorCitzdGF0aWMgdm9pZCBwZXJmX2V2
ZW50X2JwX3Nob3coc3RydWN0IHNlcV9maWxlICptLAorCQkJICAgICAgIF9fdTMyIGJwX3R5cGUs
IF9fdTMyIGJwX2FkZHIsIF9fdTMyIGJwX2xlbikKK3sKKwljaGFyICpuYW1lOworCisJc2VxX3By
aW50ZihtLCAiYXR0ci5icF90eXBlOlx0XHQiKTsKKwlzd2l0Y2ggKGJwX3R5cGUpIHsKKwljYXNl
IEhXX0JSRUFLUE9JTlRfRU1QVFk6CisJCW5hbWUgPSAiRU1QVFkiOworCQlicmVhazsKKwljYXNl
IEhXX0JSRUFLUE9JTlRfUjoKKwkJbmFtZSA9ICJSIjsKKwkJYnJlYWs7CisJY2FzZSBIV19CUkVB
S1BPSU5UX1c6CisJCW5hbWUgPSAiVyI7CisJCWJyZWFrOworCWNhc2UgSFdfQlJFQUtQT0lOVF9S
VzoKKwkJbmFtZSA9ICJSVyI7CisJCWJyZWFrOworCWNhc2UgSFdfQlJFQUtQT0lOVF9YOgorCQlu
YW1lID0gIlgiOworCQlicmVhazsKKwljYXNlIEhXX0JSRUFLUE9JTlRfSU5WQUxJRDoKKwkJbmFt
ZSA9ICJJTlZBTElEIjsKKwkJYnJlYWs7CisJZGVmYXVsdDoKKwkJbmFtZSA9ICJOVUxMIjsKKwl9
CisJc2VxX3ByaW50ZihtLCAiJXNcbiIsIG5hbWUpOworCisJc2VxX3ByaW50ZihtLCAiYXR0ci5i
cF9hZGRyOlx0XHQweCV4XG4iLCBicF9hZGRyKTsKKwlzZXFfcHJpbnRmKG0sICJhdHRyLmJwX2xl
bjpcdFx0JWRcbiIsIGJwX2xlbik7Cit9CisKK3N0YXRpYyB2b2lkIHBlcmZfZXZlbnRfYXR0cl9z
aG93KHN0cnVjdCBzZXFfZmlsZSAqbSwKKwkJCQkgc3RydWN0IHBlcmZfZXZlbnRfYXR0ciAqYXR0
cikKK3sKKwlzdGF0aWMgY29uc3QgY2hhciAqIGNvbnN0IHR5cGVfbmFtZVtdID0geworCQkiSEFS
RFdBUkUiLAorCQkiU09GVFdBUkUiLAorCQkiVFJBQ0VQT0lOVCIsCisJCSJIV19DQUNIRSIsCisJ
CSJSQVciLAorCQkiQlJFQUtQT0lOVCIKKwl9OworCisJc2VxX3ByaW50ZihtLCAiYXR0ci50eXBl
Olx0XHQlc1xuIiwgdHlwZV9uYW1lW2F0dHItPnR5cGVdKTsKKwlzZXFfcHJpbnRmKG0sICJhdHRy
LmNvbmZpZzpcdFx0JWxsdVxuIiwgYXR0ci0+Y29uZmlnKTsKKwlwZXJmX2F0dHJfc2FtcGxlX3R5
cGVfc2hvdyhtLCBhdHRyLT5zYW1wbGVfdHlwZSk7CisJcGVyZl9ldmVudF9icF9zaG93KG0sIGF0
dHItPmJwX3R5cGUsIGF0dHItPmJwX2FkZHIsIGF0dHItPmJwX2xlbik7Cit9CisKK3N0YXRpYyBp
bnQgcGVyZl9ldmVudHNfcHJvY19zaG93KHN0cnVjdCBzZXFfZmlsZSAqbSwgdm9pZCAqdikKK3sK
KwlzdHJ1Y3QgcGVyZl9ldmVudCAqZXZlbnQ7CisJaW50IGkgPSAwOworCisJbXV0ZXhfbG9jaygm
cGVyZl9ldmVudHNfbG9jayk7CisJbGlzdF9mb3JfZWFjaF9lbnRyeShldmVudCwgJnBlcmZfZXZl
bnRzX2xpc3QsIHBlcmZfZW50cnkpIHsKKwkJaSsrOworCQlzZXFfcHJpbnRmKG0sICIlZDpcbiIs
IGkpOworCQlzZXFfcHJpbnRmKG0sICJwbXU6XHRcdFx0JXNcbiIsCisJCQkJZXZlbnQtPnBtdSA/
IGV2ZW50LT5wbXUtPm5hbWUgOiAiTlVMTCIpOworCQlzZXFfcHJpbnRmKG0sICJzdGF0ZTpcdFx0
XHQlc1xuIiwKKwkJCQlwZXJmX3N0YXRlX25hbWUoZXZlbnQtPnN0YXRlKSk7CisJCXBlcmZfYXR0
YWNoX3N0YXRlX3Nob3cobSwgZXZlbnQtPmF0dGFjaF9zdGF0ZSk7CisJCXNlcV9wcmludGYobSwg
ImNwdTpcdFx0XHQlZFxuIiwgZXZlbnQtPmNwdSk7CisJCXNlcV9wcmludGYobSwgImNvdW50Olx0
XHRcdCVsbHVcbiIsCisJCQkJbG9jYWw2NF9yZWFkKCZldmVudC0+Y291bnQpKTsKKwkJc2VxX3By
aW50ZihtLCAiaWQ6XHRcdFx0JWxsdVxuIiwgZXZlbnQtPmlkKTsKKwkJcGVyZl9ldmVudF9hdHRy
X3Nob3cobSwgJmV2ZW50LT5hdHRyKTsKKworCQlzZXFfcHV0YyhtLCAnXG4nKTsKKwl9CisJbXV0
ZXhfdW5sb2NrKCZwZXJmX2V2ZW50c19sb2NrKTsKKworCXJldHVybiAwOworfQorCitzdGF0aWMg
aW50IHBlcmZfZXZlbnRzX3Byb2Nfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmls
ZSAqZmlsZSkKK3sKKwlyZXR1cm4gc2luZ2xlX29wZW4oZmlsZSwgcGVyZl9ldmVudHNfcHJvY19z
aG93LCBOVUxMKTsKK30KKworc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgcGVy
Zl9ldmVudHNfcHJvY19mb3BzID0geworCS5vcGVuICAgICAgICAgICA9IHBlcmZfZXZlbnRzX3By
b2Nfb3BlbiwKKwkucmVhZCAgICAgICAgICAgPSBzZXFfcmVhZCwKKwkubGxzZWVrICAgICAgICAg
PSBzZXFfbHNlZWssCisJLnJlbGVhc2UgICAgICAgID0gc2luZ2xlX3JlbGVhc2UsCit9OworCitz
dGF0aWMgaW50IF9faW5pdCBwcm9jX3BlcmZfZXZlbnRzX2luaXQodm9pZCkKK3sKKwlwcm9jX2Ny
ZWF0ZSgicGVyZl9ldmVudHMiLCAwNDQ0LCBOVUxMLCAmcGVyZl9ldmVudHNfcHJvY19mb3BzKTsK
KwlyZXR1cm4gMDsKK30KKworZGV2aWNlX2luaXRjYWxsKHByb2NfcGVyZl9ldmVudHNfaW5pdCk7
Ci0tIAoxLjcuOS43Cgo=
--e0cb4e6ffbf73808ec04c41ffc8f--
