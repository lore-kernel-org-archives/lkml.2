Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab2F1BCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:02:06 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33340 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2F1BCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:02:04 -0400
MIME-Version: 1.0
In-Reply-To: <87bok7x0e1.fsf@sejong.aot.lge.com>
References: <CACV3sb+EqVR0Z7qtCOpFtmRS+7xvv0b4S0Jrk7o7b__89_WVcA@mail.gmail.com>
	<87bok7x0e1.fsf@sejong.aot.lge.com>
Date: Thu, 28 Jun 2012 09:02:02 +0800
Message-ID: <CACV3sbKJiORogfjjRfyFz4Vw7Re8EYZ7K+vuU6GCb5d7w=ZgzQ@mail.gmail.com>
Subject: Re: perf support user-space hw_breakpoint?
From: Jovi Zhang <bookjovi@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6de16fa328a8204c37de1f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6de16fa328a8204c37de1f0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi

On Mon, Jun 25, 2012 at 4:26 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi, Jovi
>
> On Mon, 25 Jun 2012 13:22:01 +0800, Jovi Zhang wrote:
>> Hi guys,
>>
>> Does perf support user space hw_breakpoint based on per-task?
>>
>> perf already support kenerl space hw_breakpoint, but there don't have
>> any example for
>> user-space hw_breakpoint in code base(and never metion it).
>> From perf api point of view, it should support per-task hw_breakpoint ea=
sily.
>> but I still want to make sure that?(badly I don't have any linux
>> machine to test it now:))
>>
>
> Here is my simple test:
>
> namhyung@sejong:perf$ nm -nD /usr/bin/ls | grep D
> 0000000000619ce0 D quoting_style_args
> 000000000061a530 D ls_mode
> 000000000061a538 D Version
> 000000000061a540 D argmatch_die
> 000000000061a548 D exit_failure
>
> namhyung@sejong:perf$ ./perf stat -e mem:0x61a530 -e mem:0x61a538 -- /usr=
/bin/ls > /dev/null
>
> =C2=A0Performance counter stats for '/usr/bin/ls':
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 mem:0x61a530:rw
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 mem:0x61a538:rw
>
> =C2=A0 =C2=A0 =C2=A0 0.002213595 seconds time elapsed
>
>
> So, it should work on user-space hw_breakpoints.

Thanks very much, it works.

>
> BTW, when I perf record on a hwbp, it failed with ENOSPC.
> I guess it's because each per-task-per-cpu event tried to
> create an event so it'd get more than supported by h/w.
> The strace told me that the fifth call to perf_event_open
> failed on my 6-core machine.
>
> Thanks,
> Namhyung

I have same result as you in my linux box.
This should be a bug cause by commit d1cb9f(perf target: Add uses_mmap fiel=
d)

Namhyung, How about below patch?


>From 4b77b99df9ca3b99be4ccf8c4256e622aae9203f Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Thu, 28 Jun 2012 07:49:41 +0800
Subject: [PATCH] perf: revert commit d1cb9f(perf target: Add uses_mmap fiel=
d)

In my x86 4 cores cpu linux machine, using hw_breakpoint output as follows:

Before add uses_mmap field:
=C2=A0[root@jovi perf]# ./perf record -g -e mem:0x080652c8 -e mem:0x1098 --
/usr/bin/ls >/dev/null
=C2=A0[ perf record: Woken up 1 times to write data ]
=C2=A0[ perf record: Captured and wrote 0.015 MB perf.data (~640 samples) ]

After add uses_mmap field:
=C2=A0[root@jovi perf]# ./perf record -e mem:0x080652c8 -e mem:0x1098 --
/usr/bin/ls >/dev/null
=C2=A0 =C2=A0Error: sys_perf_event_open() syscall returned with 28 (No spac=
e
left on device). =C2=A0/bin/dmesg may provide additional information.

=C2=A0 =C2=A0Fatal: No CONFIG_PERF_EVENTS=3Dy kernel support configured?

Adding uses_mmap field in target structure will cause perf-record
creat per-task-per-cpu
event for each evsel, this will break hw_breakpoint(have limit debug
registers in cpu),
in above example, we should create dummy cpumap for hw_breakpoint
event, not per-task-per-cpu,
fix it.

Noticed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
tools/perf/builtin-record.c | =C2=A0 =C2=A03 ---
tools/perf/builtin-test.c =C2=A0 | =C2=A0 =C2=A01 -
tools/perf/builtin-top.c =C2=A0 =C2=A0| =C2=A0 =C2=A03 ---
tools/perf/util/evlist.c =C2=A0 =C2=A0| =C2=A0 =C2=A04 +---
tools/perf/util/target.h =C2=A0 =C2=A0| =C2=A0 =C2=A01 -
5 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f95840d..8128213 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -754,9 +754,6 @@ static struct perf_record record =3D {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.user_freq =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D UINT_MAX,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.user_interval =C2=
=A0 =C2=A0 =C2=A0 =3D ULLONG_MAX,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.freq =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D 4000,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .target =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D {
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 .uses_mmap =C2=A0 =3D true,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 },
=C2=A0 =C2=A0 =C2=A0 =C2=A0},
=C2=A0 =C2=A0 =C2=A0 =C2=A0.write_mode =3D WRITE_FORCE,
=C2=A0 =C2=A0 =C2=A0 =C2=A0.file_new =C2=A0 =3D true,
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 5a8727c..338a0cc 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -647,7 +647,6 @@ static int test__PERF_RECORD(void)
=C2=A0 =C2=A0 =C2=A0 =C2=A0struct perf_record_opts opts =3D {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.target =3D {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0.uid =3D UINT_MAX,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 .uses_mmap =3D true,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0},
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.no_delay =C2=A0 =3D=
 true,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.freq =C2=A0 =C2=A0 =
=C2=A0 =3D 10,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6bb0277..cc78e06 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1165,9 +1165,6 @@ int cmd_top(int argc, const char **argv, const
char *prefix __used)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.freq =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D 4000, /* 4 KHz */
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.mmap_pages =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D 128,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.sym_pcnt_filter =C2=
=A0 =C2=A0 =3D 5,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .target =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D {
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 .uses_mmap =C2=A0 =3D true,
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 },
=C2=A0 =C2=A0 =C2=A0 =C2=A0};
=C2=A0 =C2=A0 =C2=A0 =C2=A0char callchain_default_opt[] =3D "fractal,0.5,ca=
llee";
=C2=A0 =C2=A0 =C2=A0 =C2=A0const struct option options[] =3D {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7400fb3..e791029 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -622,9 +622,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist=
,
=C2=A0 =C2=A0 =C2=A0 =C2=A0if (evlist->threads =3D=3D NULL)
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -1;

- =C2=A0 =C2=A0 =C2=A0 if (perf_target__has_task(target))
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 evlist->cpus =3D cpu_map=
__dummy_new();
- =C2=A0 =C2=A0 =C2=A0 else if (!perf_target__has_cpu(target) && !target->u=
ses_mmap)
+ =C2=A0 =C2=A0 =C2=A0 if (perf_target__has_task(target) || !perf_target__h=
as_cpu(target))
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0evlist->cpus =3D cpu=
_map__dummy_new();
=C2=A0 =C2=A0 =C2=A0 =C2=A0else
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0evlist->cpus =3D cpu=
_map__new(target->cpu_list);
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index a4be857..c43f632 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -11,7 +11,6 @@ struct perf_target {
=C2=A0 =C2=A0 =C2=A0 =C2=A0const char =C2=A0 *uid_str;
=C2=A0 =C2=A0 =C2=A0 =C2=A0uid_t =C2=A0 =C2=A0 =C2=A0 =C2=A0uid;
=C2=A0 =C2=A0 =C2=A0 =C2=A0bool =C2=A0 =C2=A0 =C2=A0 =C2=A0 system_wide;
- =C2=A0 =C2=A0 =C2=A0 bool =C2=A0 =C2=A0 =C2=A0 =C2=A0 uses_mmap;
};

enum perf_target_errno {
--
1.7.9.7

--0016e6de16fa328a8204c37de1f0
Content-Type: application/octet-stream; 
	name="0001-perf-revert-commit-d1cb9f-perf-target-Add-uses_mmap-.patch"
Content-Disposition: attachment; 
	filename="0001-perf-revert-commit-d1cb9f-perf-target-Add-uses_mmap-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h3z4mul60

RnJvbSA0Yjc3Yjk5ZGY5Y2EzYjk5YmU0Y2NmOGM0MjU2ZTYyMmFhZTkyMDNmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb3ZpIFpoYW5nIDxib29ram92aUBnbWFpbC5jb20+CkRhdGU6
IFRodSwgMjggSnVuIDIwMTIgMDc6NDk6NDEgKzA4MDAKU3ViamVjdDogW1BBVENIXSBwZXJmOiBy
ZXZlcnQgY29tbWl0IGQxY2I5ZihwZXJmIHRhcmdldDogQWRkIHVzZXNfbW1hcCBmaWVsZCkKCklu
IG15IHg4NiA0IGNvcmVzIGNwdSBsaW51eCBtYWNoaW5lLCB1c2luZyBod19icmVha3BvaW50IG91
dHB1dCBhcyBmb2xsb3dzOgoKQmVmb3JlIGFkZCB1c2VzX21tYXAgZmllbGQ6CiAgW3Jvb3RAam92
aSBwZXJmXSMgLi9wZXJmIHJlY29yZCAtZyAtZSBtZW06MHgwODA2NTJjOCAtZSBtZW06MHgxMDk4
IC0tIC91c3IvYmluL2xzID4vZGV2L251bGwKICBbIHBlcmYgcmVjb3JkOiBXb2tlbiB1cCAxIHRp
bWVzIHRvIHdyaXRlIGRhdGEgXQogIFsgcGVyZiByZWNvcmQ6IENhcHR1cmVkIGFuZCB3cm90ZSAw
LjAxNSBNQiBwZXJmLmRhdGEgKH42NDAgc2FtcGxlcykgXQoKQWZ0ZXIgYWRkIHVzZXNfbW1hcCBm
aWVsZDoKICBbcm9vdEBqb3ZpIHBlcmZdIyAuL3BlcmYgcmVjb3JkIC1lIG1lbToweDA4MDY1MmM4
IC1lIG1lbToweDEwOTggLS0gL3Vzci9iaW4vbHMgPi9kZXYvbnVsbAogICAgRXJyb3I6IHN5c19w
ZXJmX2V2ZW50X29wZW4oKSBzeXNjYWxsIHJldHVybmVkIHdpdGggMjggKE5vIHNwYWNlIGxlZnQg
b24gZGV2aWNlKS4gIC9iaW4vZG1lc2cgbWF5IHByb3ZpZGUgYWRkaXRpb25hbCBpbmZvcm1hdGlv
bi4KCiAgICBGYXRhbDogTm8gQ09ORklHX1BFUkZfRVZFTlRTPXkga2VybmVsIHN1cHBvcnQgY29u
ZmlndXJlZD8KCkFkZGluZyB1c2VzX21tYXAgZmllbGQgaW4gdGFyZ2V0IHN0cnVjdHVyZSB3aWxs
IGNhdXNlIHBlcmYtcmVjb3JkIGNyZWF0IHBlci10YXNrLXBlci1jcHUKZXZlbnQgZm9yIGVhY2gg
ZXZzZWwsIHRoaXMgd2lsbCBicmVhayBod19icmVha3BvaW50KGhhdmUgbGltaXQgZGVidWcgcmVn
aXN0ZXJzIGluIGNwdSksCmluIGFib3ZlIGV4YW1wbGUsIHdlIHNob3VsZCBjcmVhdGUgZHVtbXkg
Y3B1bWFwIGZvciBod19icmVha3BvaW50IGV2ZW50LCBub3QgcGVyLXRhc2stcGVyLWNwdSwKZml4
IGl0LgoKTm90aWNlZC1ieTogTmFtaHl1bmcgS2ltIDxuYW1oeXVuZ0BrZXJuZWwub3JnPgpTaWdu
ZWQtb2ZmLWJ5OiBKb3ZpIFpoYW5nIDxib29ram92aUBnbWFpbC5jb20+Ci0tLQogdG9vbHMvcGVy
Zi9idWlsdGluLXJlY29yZC5jIHwgICAgMyAtLS0KIHRvb2xzL3BlcmYvYnVpbHRpbi10ZXN0LmMg
ICB8ICAgIDEgLQogdG9vbHMvcGVyZi9idWlsdGluLXRvcC5jICAgIHwgICAgMyAtLS0KIHRvb2xz
L3BlcmYvdXRpbC9ldmxpc3QuYyAgICB8ICAgIDQgKy0tLQogdG9vbHMvcGVyZi91dGlsL3Rhcmdl
dC5oICAgIHwgICAgMSAtCiA1IGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxMSBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS90b29scy9wZXJmL2J1aWx0aW4tcmVjb3JkLmMgYi90b29s
cy9wZXJmL2J1aWx0aW4tcmVjb3JkLmMKaW5kZXggZjk1ODQwZC4uODEyODIxMyAxMDA2NDQKLS0t
IGEvdG9vbHMvcGVyZi9idWlsdGluLXJlY29yZC5jCisrKyBiL3Rvb2xzL3BlcmYvYnVpbHRpbi1y
ZWNvcmQuYwpAQCAtNzU0LDkgKzc1NCw2IEBAIHN0YXRpYyBzdHJ1Y3QgcGVyZl9yZWNvcmQgcmVj
b3JkID0gewogCQkudXNlcl9mcmVxCSAgICAgPSBVSU5UX01BWCwKIAkJLnVzZXJfaW50ZXJ2YWwJ
ICAgICA9IFVMTE9OR19NQVgsCiAJCS5mcmVxCQkgICAgID0gNDAwMCwKLQkJLnRhcmdldAkJICAg
ICA9IHsKLQkJCS51c2VzX21tYXAgICA9IHRydWUsCi0JCX0sCiAJfSwKIAkud3JpdGVfbW9kZSA9
IFdSSVRFX0ZPUkNFLAogCS5maWxlX25ldyAgID0gdHJ1ZSwKZGlmZiAtLWdpdCBhL3Rvb2xzL3Bl
cmYvYnVpbHRpbi10ZXN0LmMgYi90b29scy9wZXJmL2J1aWx0aW4tdGVzdC5jCmluZGV4IDVhODcy
N2MuLjMzOGEwY2MgMTAwNjQ0Ci0tLSBhL3Rvb2xzL3BlcmYvYnVpbHRpbi10ZXN0LmMKKysrIGIv
dG9vbHMvcGVyZi9idWlsdGluLXRlc3QuYwpAQCAtNjQ3LDcgKzY0Nyw2IEBAIHN0YXRpYyBpbnQg
dGVzdF9fUEVSRl9SRUNPUkQodm9pZCkKIAlzdHJ1Y3QgcGVyZl9yZWNvcmRfb3B0cyBvcHRzID0g
ewogCQkudGFyZ2V0ID0gewogCQkJLnVpZCA9IFVJTlRfTUFYLAotCQkJLnVzZXNfbW1hcCA9IHRy
dWUsCiAJCX0sCiAJCS5ub19kZWxheSAgID0gdHJ1ZSwKIAkJLmZyZXEJICAgID0gMTAsCmRpZmYg
LS1naXQgYS90b29scy9wZXJmL2J1aWx0aW4tdG9wLmMgYi90b29scy9wZXJmL2J1aWx0aW4tdG9w
LmMKaW5kZXggNmJiMDI3Ny4uY2M3OGUwNiAxMDA2NDQKLS0tIGEvdG9vbHMvcGVyZi9idWlsdGlu
LXRvcC5jCisrKyBiL3Rvb2xzL3BlcmYvYnVpbHRpbi10b3AuYwpAQCAtMTE2NSw5ICsxMTY1LDYg
QEAgaW50IGNtZF90b3AoaW50IGFyZ2MsIGNvbnN0IGNoYXIgKiphcmd2LCBjb25zdCBjaGFyICpw
cmVmaXggX191c2VkKQogCQkuZnJlcQkJICAgICA9IDQwMDAsIC8qIDQgS0h6ICovCiAJCS5tbWFw
X3BhZ2VzCSAgICAgPSAxMjgsCiAJCS5zeW1fcGNudF9maWx0ZXIgICAgID0gNSwKLQkJLnRhcmdl
dAkJICAgICA9IHsKLQkJCS51c2VzX21tYXAgICA9IHRydWUsCi0JCX0sCiAJfTsKIAljaGFyIGNh
bGxjaGFpbl9kZWZhdWx0X29wdFtdID0gImZyYWN0YWwsMC41LGNhbGxlZSI7CiAJY29uc3Qgc3Ry
dWN0IG9wdGlvbiBvcHRpb25zW10gPSB7CmRpZmYgLS1naXQgYS90b29scy9wZXJmL3V0aWwvZXZs
aXN0LmMgYi90b29scy9wZXJmL3V0aWwvZXZsaXN0LmMKaW5kZXggNzQwMGZiMy4uZTc5MTAyOSAx
MDA2NDQKLS0tIGEvdG9vbHMvcGVyZi91dGlsL2V2bGlzdC5jCisrKyBiL3Rvb2xzL3BlcmYvdXRp
bC9ldmxpc3QuYwpAQCAtNjIyLDkgKzYyMiw3IEBAIGludCBwZXJmX2V2bGlzdF9fY3JlYXRlX21h
cHMoc3RydWN0IHBlcmZfZXZsaXN0ICpldmxpc3QsCiAJaWYgKGV2bGlzdC0+dGhyZWFkcyA9PSBO
VUxMKQogCQlyZXR1cm4gLTE7CiAKLQlpZiAocGVyZl90YXJnZXRfX2hhc190YXNrKHRhcmdldCkp
Ci0JCWV2bGlzdC0+Y3B1cyA9IGNwdV9tYXBfX2R1bW15X25ldygpOwotCWVsc2UgaWYgKCFwZXJm
X3RhcmdldF9faGFzX2NwdSh0YXJnZXQpICYmICF0YXJnZXQtPnVzZXNfbW1hcCkKKwlpZiAocGVy
Zl90YXJnZXRfX2hhc190YXNrKHRhcmdldCkgfHwgIXBlcmZfdGFyZ2V0X19oYXNfY3B1KHRhcmdl
dCkpCiAJCWV2bGlzdC0+Y3B1cyA9IGNwdV9tYXBfX2R1bW15X25ldygpOwogCWVsc2UKIAkJZXZs
aXN0LT5jcHVzID0gY3B1X21hcF9fbmV3KHRhcmdldC0+Y3B1X2xpc3QpOwpkaWZmIC0tZ2l0IGEv
dG9vbHMvcGVyZi91dGlsL3RhcmdldC5oIGIvdG9vbHMvcGVyZi91dGlsL3RhcmdldC5oCmluZGV4
IGE0YmU4NTcuLmM0M2Y2MzIgMTAwNjQ0Ci0tLSBhL3Rvb2xzL3BlcmYvdXRpbC90YXJnZXQuaAor
KysgYi90b29scy9wZXJmL3V0aWwvdGFyZ2V0LmgKQEAgLTExLDcgKzExLDYgQEAgc3RydWN0IHBl
cmZfdGFyZ2V0IHsKIAljb25zdCBjaGFyICAgKnVpZF9zdHI7CiAJdWlkX3QJICAgICB1aWQ7CiAJ
Ym9vbAkgICAgIHN5c3RlbV93aWRlOwotCWJvb2wJICAgICB1c2VzX21tYXA7CiB9OwogCiBlbnVt
IHBlcmZfdGFyZ2V0X2Vycm5vIHsKLS0gCjEuNy45LjcKCg==
--0016e6de16fa328a8204c37de1f0--
