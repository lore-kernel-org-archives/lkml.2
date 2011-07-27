Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab1G0SwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:52:04 -0400
Received: from jaguar.mail.utk.edu ([160.36.0.84]:52414 "EHLO
	jaguar.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1G0SwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:52:00 -0400
Date: Wed, 27 Jul 2011 14:51:47 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [perf] overflow/perf_count_sw_cpu_clock crashes recent kernels
In-Reply-To: <alpine.DEB.2.00.1107221210160.21367@cl320.eecs.utk.edu>
Message-ID: <alpine.DEB.2.00.1107271446460.406@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1107221210160.21367@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-460015126-1311792708=:406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-460015126-1311792708=:406
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hello

> With 3.0.0 the PAPI "overflow_allcounters" test reliably locks up my 
> Nehalem system.

I finally managed to narrow this down to a small test, which is attached.

Basically measuring overflow on the perf::perf_count_sw_cpu_clock
event will potentially *lock up* your system from user-space.

This seems to be a long standing bug.  It will quickly lock solid
my Nehalem test box on 3.0, 2.6.39 and 2.6.38.

On a Core2 2.6.32 box the crash testing program will wedge and become 
unkillable, but it doesn't actually kill the machine.

As mentioned before, on the Nehalem machine the following warning happens
before the machine becomes unusable:

[  392.504845] ------------[ cut here ]------------
[  392.504962] WARNING: at kernel/smp.c:320 smp_call_function_single+0x6c/0xf2()
[  392.505074] Hardware name: Precision M4500
[  392.505181] Modules linked in: acpi_cpufreq cpufreq_conservative mperf cpufreq_powersave cpufreq_userspace cpufreq_stats uinput nouveau snd_hda_codec_hdmi ttm drm_kms_helper mxm_wmi snd_hda_codec_idt iwlagn mac80211 snd_hda_intel snd_hda_codec cfg80211 dell_laptop snd_hwdep video processor ehci_hcd dell_wmi sparse_keymap psmouse sdhci_pci rfkill snd_pcm sdhci thermal_sys pcspkr ac battery wmi serio_raw snd_timer snd_page_alloc evdev i2c_i801 dcdbas button
[  392.509709] Pid: 2310, comm: overflow_allcou Not tainted 3.0.0 #43
[  392.509819] Call Trace:
[  392.509925]  <IRQ>  [<ffffffff81041bb0>] ? warn_slowpath_common+0x78/0x8c
[  392.510144]  [<ffffffff810a4d19>] ? perf_exclude_event.part.23+0x31/0x31
[  392.510257]  [<ffffffff8106b7c5>] ? smp_call_function_single+0x6c/0xf2
[  392.510369]  [<ffffffff810a38aa>] ? task_function_call+0x42/0x4c
[  392.510476]  [<ffffffff810a50e4>] ? update_cgrp_time_from_event+0x2c/0x2c
[  392.510589]  [<ffffffff810a5a9d>] ? perf_event_disable+0x45/0x8c
[  392.510700]  [<ffffffff810a8e89>] ? __perf_event_overflow+0xf1/0x1a3
[  392.510812]  [<ffffffff8103c7bb>] ? select_task_rq_fair+0x349/0x574
[  392.510924]  [<ffffffff810a7f0a>] ? perf_ctx_adjust_freq+0x42/0xe6
[  392.511038]  [<ffffffff8105f152>] ? sched_clock_cpu+0xb/0xc3
[  392.511152]  [<ffffffff8100ded5>] ? paravirt_read_tsc+0x5/0x8
[  392.511262]  [<ffffffff8100e320>] ? native_sched_clock+0x27/0x2f
[  392.511366]  [<ffffffff810a9500>] ? perf_event_overflow+0x10/0x10
[  392.511476]  [<ffffffff810a959f>] ? perf_swevent_hrtimer+0x9f/0xda
[  392.511599]  [<ffffffff8105ca04>] ? run_posix_cpu_timers+0x23/0x346
[  392.511721]  [<ffffffff8131c2ef>] ? rb_insert_color+0xb1/0xd9
[  392.511841]  [<ffffffff8105d373>] ? __run_hrtimer+0xac/0x135
[  392.511960]  [<ffffffff8105daa3>] ? hrtimer_interrupt+0xdb/0x195
[  392.512083]  [<ffffffff8108d040>] ? check_for_new_grace_period.isra.32+0x99/0xa4
[  392.512220]  [<ffffffff8108d201>] ? __rcu_process_callbacks+0x72/0x2b7
[  392.512345]  [<ffffffff8102437c>] ? hpet_interrupt_handler+0x23/0x2b
[  392.512469]  [<ffffffff81089446>] ? handle_irq_event_percpu+0x50/0x180
[  392.512592]  [<ffffffff81046f76>] ? __do_softirq+0x13e/0x177
[  392.512713]  [<ffffffff810f680c>] ? send_sigio+0x95/0xab
[  392.512832]  [<ffffffff810895aa>] ? handle_irq_event+0x34/0x52
[  392.512952]  [<ffffffff8108b433>] ? handle_edge_irq+0x9f/0xc6
[  392.513072]  [<ffffffff8100a831>] ? handle_irq+0x1d/0x21
[  392.513192]  [<ffffffff8100a561>] ? do_IRQ+0x42/0x98
[  392.513314]  [<ffffffff81593053>] ? common_interrupt+0x13/0x13
[  392.513438]  <EOI> 
[  392.513542] ---[ end trace 12f3f913316a2866 ]---

Thanks,

Vince

--8323329-460015126-1311792708=:406
Content-Type: TEXT/x-csrc; name=oflo_sw_cpu_clock_crash.c
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.1107271451470.406@cl320.eecs.utk.edu>
Content-Description: 
Content-Disposition: attachment; filename=oflo_sw_cpu_clock_crash.c

LyogRXJyb3Igd2l0aCBvdmVyZmxvd3MgYW5kIHBlcmY6OnBlcmZfY291bnRf
c3dfY3B1X2Nsb2NrICAgICAgICAgICAgICAgICAgICAqLw0KLyogVGhpcyB0
ZXN0IHdpbGwgY3Jhc2ggTGludXggMy4wLjAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAqLw0KLyogY29tcGlsZSB3aXRoIGdj
YyAtTzIgLW8gb2Zsb19zd19jcHVfY2xvY2tfY3Jhc2ggb2Zsb19zd19jcHVf
Y2xvY2tfY3Jhc2guYyAqLw0KDQovKiBieSBWaW5jZSBXZWF2ZXIgPHZ3ZWF2
ZXIxIF9hdF8gZWVjcy51dGsuZWR1PiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICovDQoNCiNkZWZpbmUgX0dOVV9TT1VSQ0UgMQ0KDQojaW5jbHVk
ZSA8c3RkaW8uaD4NCiNpbmNsdWRlIDxzdGRsaWIuaD4NCiNpbmNsdWRlIDxz
dHJpbmcuaD4NCg0KI2luY2x1ZGUgPGZjbnRsLmg+DQoNCg0KI2luY2x1ZGUg
PGxpbnV4L3BlcmZfZXZlbnQuaD4NCiNpbmNsdWRlIDxzeXMvc3lzY2FsbC5o
Pg0KI2luY2x1ZGUgPHVuaXN0ZC5oPg0KI2luY2x1ZGUgPGFzbS91bmlzdGQu
aD4NCiNpbmNsdWRlIDxzeXMvaW9jdGwuaD4NCg0KI2luY2x1ZGUgPHN5cy9t
bWFuLmg+DQoNCiNpbmNsdWRlIDxzaWduYWwuaD4NCg0KDQojaW5jbHVkZSA8
c3lzL3ByY3RsLmg+DQoNCiNkZWZpbmUgTUFUUklYX1NJWkUgNTEyDQpzdGF0
aWMgZG91YmxlIGFbTUFUUklYX1NJWkVdW01BVFJJWF9TSVpFXTsNCnN0YXRp
YyBkb3VibGUgYltNQVRSSVhfU0laRV1bTUFUUklYX1NJWkVdOw0Kc3RhdGlj
IGRvdWJsZSBjW01BVFJJWF9TSVpFXVtNQVRSSVhfU0laRV07DQoNCnN0YXRp
YyB2b2lkIG5haXZlX21hdHJpeF9tdWx0aXBseShpbnQgcXVpZXQpIHsNCg0K
ICBkb3VibGUgczsNCiAgaW50IGksaixrOw0KDQogIGZvcihpPTA7aTxNQVRS
SVhfU0laRTtpKyspIHsNCiAgICBmb3Ioaj0wO2o8TUFUUklYX1NJWkU7aisr
KSB7DQogICAgICBhW2ldW2pdPShkb3VibGUpaSooZG91YmxlKWo7DQogICAg
ICBiW2ldW2pdPShkb3VibGUpaS8oZG91YmxlKShqKzUpOw0KICAgIH0NCiAg
fQ0KDQogIGZvcihqPTA7ajxNQVRSSVhfU0laRTtqKyspIHsNCiAgICAgZm9y
KGk9MDtpPE1BVFJJWF9TSVpFO2krKykgew0KICAgICAgICBzPTA7DQogICAg
ICAgIGZvcihrPTA7azxNQVRSSVhfU0laRTtrKyspIHsNCgkgICBzKz1hW2ld
W2tdKmJba11bal07DQoJfQ0KICAgICAgICBjW2ldW2pdID0gczsNCiAgICAg
fQ0KICB9DQoNCiAgcz0wLjA7DQogIGZvcihpPTA7aTxNQVRSSVhfU0laRTtp
KyspIHsNCiAgICBmb3Ioaj0wO2o8TUFUUklYX1NJWkU7aisrKSB7DQogICAg
ICBzKz1jW2ldW2pdOw0KICAgIH0NCiAgfQ0KDQogIGlmICghcXVpZXQpIHBy
aW50ZigiTWF0cml4IG11bHRpcGx5IHN1bTogcz0lbGZcbiIscyk7DQoNCiAg
cmV0dXJuOw0KfQ0KDQoNCnN0YXRpYyBpbnQgdG90YWw9MDsNCg0Kdm9pZCBv
dXJfaGFuZGxlcihpbnQgc2lnbnVtLHNpZ2luZm9fdCAqb2gsIHZvaWQgKmJs
YWgpIHsNCg0KICBpbnQgZmQ9b2gtPnNpX2ZkOw0KDQogIGlvY3RsKGZkICwg
UEVSRl9FVkVOVF9JT0NfRElTQUJMRSwwKTsNCiAgdG90YWwrKzsNCiAgaW9j
dGwoZmQgLCBQRVJGX0VWRU5UX0lPQ19SRUZSRVNILDEpOw0KfQ0KDQppbnQg
cGVyZl9ldmVudF9vcGVuKHN0cnVjdCBwZXJmX2V2ZW50X2F0dHIgKmh3X2V2
ZW50X3VwdHIsDQoJCSAgICBwaWRfdCBwaWQsIGludCBjcHUsIGludCBncm91
cF9mZCwgdW5zaWduZWQgbG9uZyBmbGFncykgew0KDQogIHJldHVybiBzeXNj
YWxsKF9fTlJfcGVyZl9ldmVudF9vcGVuLGh3X2V2ZW50X3VwdHIscGlkLGNw
dSxncm91cF9mZCxmbGFncyk7DQoNCn0NCg0KaW50IG1haW4oIGludCBhcmdj
LCBjaGFyICoqYXJndiApIHsNCg0KCWludCBmZDsNCgl2b2lkICpibGFyZ2g7
DQoNCglzdHJ1Y3QgcGVyZl9ldmVudF9hdHRyIHBlOw0KDQoJc3RydWN0IHNp
Z2FjdGlvbiBzYTsNCg0KCW1lbXNldCgmc2EsIDAsIHNpemVvZihzdHJ1Y3Qg
c2lnYWN0aW9uKSk7DQoJc2Euc2Ffc2lnYWN0aW9uPW91cl9oYW5kbGVyOw0K
CXNhLnNhX2ZsYWdzPVNBX1NJR0lORk87DQoNCglpZiAoc2lnYWN0aW9uKFNJ
R0lPLCZzYSxOVUxMKTwwKSB7DQoJICBmcHJpbnRmKHN0ZGVyciwiRXJyb3Ig
c2V0dGluZyB1cCBzaWduYWwgaGFuZGxlclxuIik7DQoJICBleGl0KDEpOw0K
CX0NCgkgICAgICANCiAgICAgICAgbWVtc2V0KCZwZSwwLHNpemVvZihzdHJ1
Y3QgcGVyZl9ldmVudF9hdHRyKSk7CQ0KCXBlLnR5cGU9UEVSRl9UWVBFX1NP
RlRXQVJFOw0KCXBlLnNpemU9c2l6ZW9mKHN0cnVjdCBwZXJmX2V2ZW50X2F0
dHIpOw0KICAgICAgICBwZS5jb25maWc9UEVSRl9DT1VOVF9TV19DUFVfQ0xP
Q0s7DQoJcGUuc2FtcGxlX3BlcmlvZD0xMDAwMDA7DQoJcGUuc2FtcGxlX3R5
cGU9UEVSRl9TQU1QTEVfSVA7DQoJcGUucmVhZF9mb3JtYXQ9UEVSRl9GT1JN
QVRfR1JPVVB8UEVSRl9GT1JNQVRfSUQ7DQoJcGUuZGlzYWJsZWQ9MTsNCglw
ZS5waW5uZWQ9MTsNCglwZS5leGNsdWRlX2tlcm5lbD0xOw0KCXBlLmV4Y2x1
ZGVfaHY9MTsNCglwZS53YWtldXBfZXZlbnRzPTE7DQoNCglmZD1wZXJmX2V2
ZW50X29wZW4oJnBlLDAsLTEsLTEsMCk7DQoJaWYgKGZkPDApIHsNCgkgICBw
cmludGYoIkVycm9yIG9wZW5pbmdcbiIpOw0KCX0NCg0KCWJsYXJnaD1tbWFw
KE5VTEwsKDErMikqNDA5NixQUk9UX1JFQUR8UFJPVF9XUklURSxNQVBfU0hB
UkVELGZkLDApOw0KCWZjbnRsKGZkLEZfU0VURkwsT19SRFdSfE9fTk9OQkxP
Q0t8T19BU1lOQyk7DQoJZmNudGwoZmQsRl9TRVRTSUcsU0lHSU8pOw0KCWZj
bnRsKGZkLEZfU0VUT1dOLGdldHBpZCgpKTsNCg0KCWlvY3RsKGZkLFBFUkZf
RVZFTlRfSU9DX1JFU0VULDApOw0KCWlvY3RsKGZkLFBFUkZfRVZFTlRfSU9D
X0VOQUJMRSwwKTsNCg0KCW5haXZlX21hdHJpeF9tdWx0aXBseSgwKTsNCg0K
CWlvY3RsKGZkLFBFUkZfRVZFTlRfSU9DX0RJU0FCTEUsMCk7DQoJbXVubWFw
KGJsYXJnaCwoMSsyKSo0MDk2KTsNCgljbG9zZShmZCk7DQoNCglwcmludGYo
IlRvdGFsIG92ZXJmbG93czogJWRcbiIsdG90YWwpOw0KDQoJcmV0dXJuIDA7
DQp9DQo=

--8323329-460015126-1311792708=:406--
