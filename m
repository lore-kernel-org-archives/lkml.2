Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab2AXSyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:54:07 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50459 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab2AXSyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:54:04 -0500
MIME-Version: 1.0
In-Reply-To: <1327363550-19952-3-git-send-email-john.stultz@linaro.org>
References: <1327363550-19952-1-git-send-email-john.stultz@linaro.org> <1327363550-19952-3-git-send-email-john.stultz@linaro.org>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 24 Jan 2012 11:53:32 -0700
Message-ID: <CAJfuBxwBfB7V_gikW44rTNAYvxKZwORwzdRrvyZM19feFwcwDQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/3] clocksource: scx200_hrt: Convert scx200 to use clocksource_register_hz
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d04447e59a845aa04b74aab05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d04447e59a845aa04b74aab05
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 23, 2012 at 5:05 PM, John Stultz <john.stultz@linaro.org> wrote=
:
> Converts the scx200 clocksource to using clocksource_register_hz.
>
> This wasn't a straight conversion, so would like some extra review
> by the maintainers.
>

hi John,

very nice.  Tested with mhz27 too.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>

It eliminates this noise that Ive started seeing recently (for some
value of recent)

enabling scx200 high-res timer (1 MHz +0 ppm)
------------[ cut here ]------------
WARNING: at /home/jimc/projects/lx/linux-2.6/kernel/time/clocksource.c:740
clocksource_register+0x78/0xbd()
Clocksource scx200_hrt might overflow on 11% adjustment
Modules linked in: scx200_hrt(+) scx200 pc8736x_gpio nsc_gpio pc87360
hwmon_vid scx200_acb ohci_hcd pata_sc1200
Pid: 291, comm: modprobe Not tainted 3.2.0-skd-00063-g296c136 #256
Call Trace:
 [<c01201a1>] warn_slowpath_common+0x7c/0x91
 [<c0140266>] ? clocksource_register+0x78/0xbd
 [<c0140266>] ? clocksource_register+0x78/0xbd
 [<c0120241>] warn_slowpath_fmt+0x33/0x35
 [<c0140266>] clocksource_register+0x78/0xbd
 [<c886412d>] init_hrt_clocksource+0x12d/0x139 [scx200_hrt]
 [<c010108b>] do_one_initcall+0x8b/0x138
 [<c8864000>] ? 0xc8863fff
 [<c014a6db>] sys_init_module+0x13ef/0x160e
 [<c042015c>] syscall_call+0x7/0xb
---[ end trace 69c8ca76cf89ab2d ]---
Switching to clocksource scx200_hrt
Loading kernel modules...chrdev_alloc_region: chrdev_alloc_region
reserves a dynamic major, but was called with major:3077.  Caller
should pass major:0 for this.
done.
------------[ cut here ]------------
WARNING: at /home/jimc/projects/lx/linux-2.6/kernel/time/timekeeping.c:863
do_timer+0x56f/0x6ae()
Adjusting scx200_hrt more then 11% (-100663808 vs 360710144)

NB - s/then/than/   Im attaching a patch for that.
Also, "when then" is a little awkward.
		/*
		 * Have to be careful here. If we're in oneshot mode,
		 * before we call tick_periodic() in a loop, we need
		 * to be sure we're using a real hardware clocksource.
		 * Otherwise we could get trapped in an infinite
		 * loop, as the tick_periodic() increments jiffies,
		 * when then will increment time, posibly causing
		 * the loop to trigger again and again.
		 */


Modules linked in: scx200_gpio scx200_hrt scx200 pc8736x_gpio nsc_gpio
pc87360 hwmon_vid scx200_acb ohci_hcd pata_sc1200
Pid: 58, comm: collector Tainted: G        W    3.2.0-skd-00063-g296c136 #2=
56
Call Trace:
 [<c01201a1>] warn_slowpath_common+0x7c/0x91
 [<c013ebbe>] ? do_timer+0x56f/0x6ae
 [<c013ebbe>] ? do_timer+0x56f/0x6ae
 [<c0120241>] warn_slowpath_fmt+0x33/0x35
 [<c013ebbe>] do_timer+0x56f/0x6ae
 [<c014319b>] tick_do_update_jiffies64+0xc0/0xee
 [<c01432e1>] tick_sched_timer+0x45/0x9e
 [<c0139c01>] ? __remove_hrtimer+0x2a/0x87
 [<c0139d81>] __run_hrtimer+0x93/0x131
 [<c014329c>] ? tick_nohz_handler+0xd3/0xd3
 [<c013a549>] hrtimer_interrupt+0xe1/0x1f4
 [<c010346d>] timer_interrupt+0x18/0x1f
 [<c015fbcf>] handle_irq_event_percpu+0x4a/0x197
 [<c014bcfe>] ? pm_qos_request+0xe/0x16
 [<c0104155>] ? mask_and_ack_8259A+0x77/0xde
 [<c0161a3c>] ? unmask_irq+0x23/0x23
 [<c015fd58>] handle_irq_event+0x3c/0x54
 [<c0161a8e>] handle_level_irq+0x52/0x80
 <IRQ>  [<c0102f2c>] ? do_IRQ+0x39/0x87
 [<c02b561a>] ? disk_seqf_start+0x2e/0x84
 [<c0424c70>] ? common_interrupt+0x30/0x40
 [<c01c007b>] ? do_vfs_ioctl+0x30c/0x481
 [<c01f21e9>] ? proc_readdir_de+0x166/0x186
 [<c01c0324>] ? filldir64+0xcc/0xcc
 [<c01f222a>] ? proc_readdir+0x21/0x25
 [<c01c0324>] ? filldir64+0xcc/0xcc
 [<c01edbe9>] ? proc_root_readdir+0x1f/0x41
 [<c01c0509>] ? vfs_readdir+0x6a/0x8f
 [<c01c0324>] ? filldir64+0xcc/0xcc
 [<c01c05e7>] ? sys_getdents+0x63/0x9f
 [<c042015c>] ? syscall_call+0x7/0xb
 [<c0420000>] ? rwsem_down_failed_common+0x5f/0xbc
---[ end trace 69c8ca76cf89ab2e ]---




> CC: Jim Cromie <jim.cromie@gmail.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
> =A0drivers/clocksource/scx200_hrt.c | =A0 19 ++++++-------------
> =A01 files changed, 6 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/clocksource/scx200_hrt.c b/drivers/clocksource/scx20=
0_hrt.c
> index 27f4d96..24f884c 100644
> --- a/drivers/clocksource/scx200_hrt.c
> +++ b/drivers/clocksource/scx200_hrt.c
> @@ -49,9 +49,6 @@ static cycle_t read_hrt(struct clocksource *cs)
> =A0 =A0 =A0 =A0return (cycle_t) inl(scx200_cb_base + SCx200_TIMER_OFFSET)=
;
> =A0}
>
> -#define HRT_SHIFT_1 =A0 =A022
> -#define HRT_SHIFT_27 =A0 26
> -
> =A0static struct clocksource cs_hrt =3D {
> =A0 =A0 =A0 =A0.name =A0 =A0 =A0 =A0 =A0 =3D "scx200_hrt",
> =A0 =A0 =A0 =A0.rating =A0 =A0 =A0 =A0 =3D 250,
> @@ -63,6 +60,7 @@ static struct clocksource cs_hrt =3D {
>
> =A0static int __init init_hrt_clocksource(void)
> =A0{
> + =A0 =A0 =A0 u32 freq;
> =A0 =A0 =A0 =A0/* Make sure scx200 has initialized the configuration bloc=
k */
> =A0 =A0 =A0 =A0if (!scx200_cb_present())
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENODEV;
> @@ -79,19 +77,14 @@ static int __init init_hrt_clocksource(void)
> =A0 =A0 =A0 =A0outb(HR_TMEN | (mhz27 ? HR_TMCLKSEL : 0),
> =A0 =A0 =A0 =A0 =A0 =A0 scx200_cb_base + SCx200_TMCNFG_OFFSET);
>
> - =A0 =A0 =A0 if (mhz27) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cs_hrt.shift =3D HRT_SHIFT_27;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cs_hrt.mult =3D clocksource_hz2mult((HRT_FR=
EQ + ppm) * 27,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 cs_hrt.shift);
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cs_hrt.shift =3D HRT_SHIFT_1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cs_hrt.mult =3D clocksource_hz2mult(HRT_FRE=
Q + ppm,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 cs_hrt.shift);
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 freq =3D (HRT_FREQ + ppm);
> + =A0 =A0 =A0 if (mhz27)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 freq *=3D 27;
> +
> =A0 =A0 =A0 =A0printk(KERN_INFO "enabling scx200 high-res timer (%s MHz +=
%d ppm)\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mhz27 ? "27":"1", ppm);
>
> - =A0 =A0 =A0 return clocksource_register(&cs_hrt);
> + =A0 =A0 =A0 return clocksource_register_hz(&cs_hrt, freq);
> =A0}
>
> =A0module_init(init_hrt_clocksource);
> --
> 1.7.3.2.146.gca209
>

--f46d04447e59a845aa04b74aab05
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-time-s-then-than-where-appropriate.patch"
Content-Disposition: attachment; 
	filename="0001-time-s-then-than-where-appropriate.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxta6qqb0

RnJvbSBmNzViMjMyMDdkNTcyOWE5ZWM3MmJhMGQwNWQ5YTA3ZTg2MjkxYjFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKaW0gQ3JvbWllIDxqaW0uY3JvbWllQGdtYWlsLmNvbT4KRGF0
ZTogVHVlLCAyNCBKYW4gMjAxMiAxMTo0Nzo1NSAtMDcwMApTdWJqZWN0OiBbUEFUQ0hdIHRpbWU6
IHMvdGhlbi90aGFuLyB3aGVyZSBhcHByb3ByaWF0ZQoKClNpZ25lZC1vZmYtYnk6IEppbSBDcm9t
aWUgPGppbS5jcm9taWVAZ21haWwuY29tPgotLS0KIGtlcm5lbC90aW1lL2Nsb2Nrc291cmNlLmMg
fCAgICAyICstCiBrZXJuZWwvdGltZS90aW1la2VlcGluZy5jIHwgICAxNiArKysrKysrKy0tLS0t
LS0tCiAyIGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9rZXJuZWwvdGltZS9jbG9ja3NvdXJjZS5jIGIva2VybmVsL3RpbWUvY2xvY2tz
b3VyY2UuYwppbmRleCBkM2FkMDIyLi5lYmY5OGZiIDEwMDY0NAotLS0gYS9rZXJuZWwvdGltZS9j
bG9ja3NvdXJjZS5jCisrKyBiL2tlcm5lbC90aW1lL2Nsb2Nrc291cmNlLmMKQEAgLTUwMCw3ICs1
MDAsNyBAQCBzdGF0aWMgdTMyIGNsb2Nrc291cmNlX21heF9hZGp1c3RtZW50KHN0cnVjdCBjbG9j
a3NvdXJjZSAqY3MpCiB7CiAJdTY0IHJldDsKIAkvKgotCSAqIFdlIHdvbid0IHRyeSB0byBjb3Jy
ZWN0IGZvciBtb3JlIHRoZW4gMTElIGFkanVzdG1lbnRzICgxMTAsMDAwIHBwbSksCisJICogV2Ug
d29uJ3QgdHJ5IHRvIGNvcnJlY3QgZm9yIG1vcmUgdGhhbiAxMSUgYWRqdXN0bWVudHMgKDExMCww
MDAgcHBtKSwKIAkgKi8KIAlyZXQgPSAodTY0KWNzLT5tdWx0ICogMTE7CiAJZG9fZGl2KHJldCwx
MDApOwpkaWZmIC0tZ2l0IGEva2VybmVsL3RpbWUvdGltZWtlZXBpbmcuYyBiL2tlcm5lbC90aW1l
L3RpbWVrZWVwaW5nLmMKaW5kZXggMjM3ODQxMy4uZTc3YzE2OCAxMDA2NDQKLS0tIGEva2VybmVs
L3RpbWUvdGltZWtlZXBpbmcuYworKysgYi9rZXJuZWwvdGltZS90aW1la2VlcGluZy5jCkBAIC04
MDcsNyArODA3LDcgQEAgc3RhdGljIHZvaWQgdGltZWtlZXBpbmdfYWRqdXN0KHM2NCBvZmZzZXQp
CiAJaW50IGFkajsKIAogCS8qCi0JICogVGhlIHBvaW50IG9mIHRoaXMgaXMgdG8gY2hlY2sgaWYg
dGhlIGVycm9yIGlzIGdyZWF0ZXIgdGhlbiBoYWxmCisJICogVGhlIHBvaW50IG9mIHRoaXMgaXMg
dG8gY2hlY2sgaWYgdGhlIGVycm9yIGlzIGdyZWF0ZXIgdGhhbiBoYWxmCiAJICogYW4gaW50ZXJ2
YWwuCiAJICoKIAkgKiBGaXJzdCB3ZSBzaGlmdCBpdCBkb3duIGZyb20gTlRQX1NISUZUIHRvIGNs
b2Nrc291cmNlLT5zaGlmdGVkIG5zZWNzLgpAQCAtODE1LDcgKzgxNSw3IEBAIHN0YXRpYyB2b2lk
IHRpbWVrZWVwaW5nX2FkanVzdChzNjQgb2Zmc2V0KQogCSAqIE5vdGUgd2Ugc3VidHJhY3Qgb25l
IGluIHRoZSBzaGlmdCwgc28gdGhhdCBlcnJvciBpcyByZWFsbHkgZXJyb3IqMi4KIAkgKiBUaGlz
ICJzYXZlcyIgZGl2aWRpbmcoc2hpZnRpbmcpIGludGVyZXJ2YWwgdHdpY2UsIGJ1dCBrZWVwcyB0
aGUKIAkgKiAoZXJyb3IgPiBpbnRlcnZhbCkgY29tcGFyaXNpb24gYXMgc3RpbGwgbWVhc3VyaW5n
IGlmIGVycm9yIGlzCi0JICogbGFyZ2VyIHRoZW4gaGFsZiBhbiBpbnRlcnZhbC4KKwkgKiBsYXJn
ZXIgdGhhbiBoYWxmIGFuIGludGVydmFsLgogCSAqCiAJICogTm90ZTogSXQgZG9lcyBub3QgInNh
dmUiIG9uIGFnZ3JpdmF0aW9uIHdoZW4gcmVhZGluZyB0aGUgY29kZS4KIAkgKi8KQEAgLTgyMyw3
ICs4MjMsNyBAQCBzdGF0aWMgdm9pZCB0aW1la2VlcGluZ19hZGp1c3QoczY0IG9mZnNldCkKIAlp
ZiAoZXJyb3IgPiBpbnRlcnZhbCkgewogCQkvKgogCQkgKiBXZSBub3cgZGl2aWRlIGVycm9yIGJ5
IDQodmlhIHNoaWZ0KSwgd2hpY2ggY2hlY2tzIGlmCi0JCSAqIHRoZSBlcnJvciBpcyBncmVhdGVy
IHRoZW4gdHdpY2UgdGhlIGludGVydmFsLgorCQkgKiB0aGUgZXJyb3IgaXMgZ3JlYXRlciB0aGFu
IHR3aWNlIHRoZSBpbnRlcnZhbC4KIAkJICogSWYgaXQgaXMgZ3JlYXRlciwgd2UgbmVlZCBhIGJp
Z2FkanVzdCwgaWYgaXRzIHNtYWxsZXIsCiAJCSAqIHdlIGNhbiBhZGp1c3QgYnkgMS4KIAkJICov
CkBAIC04NTcsNyArODU3LDcgQEAgc3RhdGljIHZvaWQgdGltZWtlZXBpbmdfYWRqdXN0KHM2NCBv
ZmZzZXQpCiAJV0FSTl9PTkNFKHRpbWVrZWVwZXIuY2xvY2stPm1heGFkaiAmJgogCQkJKHRpbWVr
ZWVwZXIubXVsdCArIGFkaiA+IHRpbWVrZWVwZXIuY2xvY2stPm11bHQgKwogCQkJCQkJdGltZWtl
ZXBlci5jbG9jay0+bWF4YWRqKSwKLQkJCSJBZGp1c3RpbmcgJXMgbW9yZSB0aGVuIDExJSUgKCVs
ZCB2cyAlbGQpXG4iLAorCQkJIkFkanVzdGluZyAlcyBtb3JlIHRoYW4gMTElJSAoJWxkIHZzICVs
ZClcbiIsCiAJCQl0aW1la2VlcGVyLmNsb2NrLT5uYW1lLCAobG9uZyl0aW1la2VlcGVyLm11bHQg
KyBhZGosCiAJCQkobG9uZyl0aW1la2VlcGVyLmNsb2NrLT5tdWx0ICsKIAkJCQl0aW1la2VlcGVy
LmNsb2NrLT5tYXhhZGopOwpAQCAtOTMyLDcgKzkzMiw3IEBAIHN0YXRpYyBjeWNsZV90IGxvZ2Fy
aXRobWljX2FjY3VtdWxhdGlvbihjeWNsZV90IG9mZnNldCwgaW50IHNoaWZ0KQogCXU2NCBuc2Vj
cHMgPSAodTY0KU5TRUNfUEVSX1NFQyA8PCB0aW1la2VlcGVyLnNoaWZ0OwogCXU2NCByYXdfbnNl
Y3M7CiAKLQkvKiBJZiB0aGUgb2Zmc2V0IGlzIHNtYWxsZXIgdGhlbiBhIHNoaWZ0ZWQgaW50ZXJ2
YWwsIGRvIG5vdGhpbmcgKi8KKwkvKiBJZiB0aGUgb2Zmc2V0IGlzIHNtYWxsZXIgdGhhbiBhIHNo
aWZ0ZWQgaW50ZXJ2YWwsIGRvIG5vdGhpbmcgKi8KIAlpZiAob2Zmc2V0IDwgdGltZWtlZXBlci5j
eWNsZV9pbnRlcnZhbDw8c2hpZnQpCiAJCXJldHVybiBvZmZzZXQ7CiAKQEAgLTk5NSwxMyArOTk1
LDEzIEBAIHN0YXRpYyB2b2lkIHVwZGF0ZV93YWxsX3RpbWUodm9pZCkKIAkgKiBXaXRoIE5PX0ha
IHdlIG1heSBoYXZlIHRvIGFjY3VtdWxhdGUgbWFueSBjeWNsZV9pbnRlcnZhbHMKIAkgKiAodGhp
bmsgInRpY2tzIikgd29ydGggb2YgdGltZSBhdCBvbmNlLiBUbyBkbyB0aGlzIGVmZmljaWVudGx5
LAogCSAqIHdlIGNhbGN1bGF0ZSB0aGUgbGFyZ2VzdCBkb3VibGluZyBtdWx0aXBsZSBvZiBjeWNs
ZV9pbnRlcnZhbHMKLQkgKiB0aGF0IGlzIHNtYWxsZXIgdGhlbiB0aGUgb2Zmc2V0LiBXZSB0aGVu
IGFjY3VtdWxhdGUgdGhhdAorCSAqIHRoYXQgaXMgc21hbGxlciB0aGFuIHRoZSBvZmZzZXQuIFdl
IHRoZW4gYWNjdW11bGF0ZSB0aGF0CiAJICogY2h1bmsgaW4gb25lIGdvLCBhbmQgdGhlbiB0cnkg
dG8gY29uc3VtZSB0aGUgbmV4dCBzbWFsbGVyCiAJICogZG91YmxlZCBtdWx0aXBsZS4KIAkgKi8K
IAlzaGlmdCA9IGlsb2cyKG9mZnNldCkgLSBpbG9nMih0aW1la2VlcGVyLmN5Y2xlX2ludGVydmFs
KTsKIAlzaGlmdCA9IG1heCgwLCBzaGlmdCk7Ci0JLyogQm91bmQgc2hpZnQgdG8gb25lIGxlc3Mg
dGhlbiB3aGF0IG92ZXJmbG93cyB0aWNrX2xlbmd0aCAqLworCS8qIEJvdW5kIHNoaWZ0IHRvIG9u
ZSBsZXNzIHRoYW4gd2hhdCBvdmVyZmxvd3MgdGlja19sZW5ndGggKi8KIAltYXhzaGlmdCA9ICg4
KnNpemVvZih0aWNrX2xlbmd0aCkgLSAoaWxvZzIodGlja19sZW5ndGgpKzEpKSAtIDE7CiAJc2hp
ZnQgPSBtaW4oc2hpZnQsIG1heHNoaWZ0KTsKIAl3aGlsZSAob2Zmc2V0ID49IHRpbWVrZWVwZXIu
Y3ljbGVfaW50ZXJ2YWwpIHsKQEAgLTEwNDcsNyArMTA0Nyw3IEBAIHN0YXRpYyB2b2lkIHVwZGF0
ZV93YWxsX3RpbWUodm9pZCkKIAogCS8qCiAJICogRmluYWxseSwgbWFrZSBzdXJlIHRoYXQgYWZ0
ZXIgdGhlIHJvdW5kaW5nCi0JICogeHRpbWUudHZfbnNlYyBpc24ndCBsYXJnZXIgdGhlbiBOU0VD
X1BFUl9TRUMKKwkgKiB4dGltZS50dl9uc2VjIGlzbid0IGxhcmdlciB0aGFuIE5TRUNfUEVSX1NF
QwogCSAqLwogCWlmICh1bmxpa2VseSh4dGltZS50dl9uc2VjID49IE5TRUNfUEVSX1NFQykpIHsK
IAkJeHRpbWUudHZfbnNlYyAtPSBOU0VDX1BFUl9TRUM7Ci0tIAoxLjcuOC4xCgo=
--f46d04447e59a845aa04b74aab05--
