Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950Ab0FKAFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 20:05:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52688 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab0FKAE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 20:04:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :message-id:references:to:x-mailer;
        b=MIvVGSl+ao/xcmivx86yidmWEIGth2AGp70ld6hwOp8oUGjPGIn26g10o6cmrXtb3O
         yQ/GvlmxZF+KQheVClgBDwJ2QB3xAENpUXoveEQqRQ0mn5/RaYqKY3hbFj0PeZS2spMG
         AWbslWD/rIVRumvpKSZCJ7GYqqLpntyGEeCTI=
Subject: Re: PROBLEM: PPP and other serial port related application hangs in kernel space
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: multipart/signed; boundary=Apple-Mail-6--592731779; protocol="application/pkcs7-signature"; micalg=sha1
From: Ales Teska <ales.teska@gmail.com>
In-Reply-To: <201006092316.32497.arnd@arndb.de>
Date: Fri, 11 Jun 2010 02:04:55 +0200
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@linux.intel.com>
Message-Id: <133A414A-128E-4764-B15D-E479DCEDDC2C@gmail.com>
References: <900E3B14-5B92-4A37-9581-049DB40F4D1C@gmail.com> <201006092316.32497.arnd@arndb.de>
To: arnd@arndb.de
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-6--592731779
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Here is a stack from 2.6.34 with few debugging options on:

# cat /proc/1390/stack=20
[<c10f79fb>] tty_ldisc_ref_wait+0x5d/0x75
[<c10f3c54>] tty_ioctl+0x6d1/0x731
[<c1077e6c>] vfs_ioctl+0x22/0x86
[<c10783ba>] do_vfs_ioctl+0x45a/0x4a5
[<c1078431>] sys_ioctl+0x2c/0x45
[<c1198e65>] syscall_call+0x7/0xb
[<ffffffff>] 0xffffffff

[  841.121579] INFO: task pppd:1390 blocked for more than 120 seconds.
[  841.122613] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" =
disables this message.
[  841.123578] pppd          D cec53ea4     0  1390   1139 0x00000000
[  841.126502]  cec53ebc 00000046 c1037b30 cec53ea4 c1198bf6 cec29070 =
cec291f8 cfdbc520
[  841.134781]  c10f7049 cec53ebc 00000000 cec51800 cec53ec4 cec53ee4 =
c10f79fb 00000000
[  841.143007]  cec29070 c102b471 c13dc904 c13dc904 d0c35211 cefc6aa0 =
cec51800 cec53f1c
[  841.151250] Call Trace:
[  841.151815]  [<c1037b30>] ? trace_hardirqs_on+0xb/0xd
[  841.152755]  [<c1198bf6>] ? _raw_spin_unlock_irqrestore+0x53/0x60
[  841.153657]  [<c10f7049>] ? spin_unlock_irqrestore+0x8/0xa
[  841.154601]  [<c10f79fb>] tty_ldisc_ref_wait+0x5d/0x75
[  841.155265]  [<c102b471>] ? autoremove_wake_function+0x0/0x33
[  841.156456]  [<d0c35211>] ? serial_ioctl+0x0/0x68 [usbserial]
[  841.157913]  [<c10f3c54>] tty_ioctl+0x6d1/0x731
[  841.158834]  [<c102fa77>] ? sched_clock_cpu+0xac/0xbc
[  841.159658]  [<c10f3583>] ? tty_ioctl+0x0/0x731
[  841.160922]  [<c1077e6c>] vfs_ioctl+0x22/0x86
[  841.161836]  [<c10783ba>] do_vfs_ioctl+0x45a/0x4a5
[  841.162746]  [<c1036a5e>] ? put_lock_stats+0xd/0x21
[  841.163699]  [<c1036ac6>] ? lock_release_holdtime+0x54/0x5a
[  841.164530]  [<c100fd87>] ? do_page_fault+0x27c/0x285
[  841.165898]  [<c102e978>] ? up_read+0x16/0x28
[  841.166820]  [<c1078431>] sys_ioctl+0x2c/0x45
[  841.167452]  [<c1198e65>] syscall_call+0x7/0xb
[  841.168403] no locks held by pppd/1390.

... strangely now I'm getting different message in the dmesg output (and =
actually +120 seconds from incident).
Ratio of hangs is now higher with this build ...

I will do a test with CONFIG_LOCKDEP & CONFIG_TTY_MUTEX options over the =
weekend.

Ales

On 9 Jun 2010, at 23:16 , arnd@arndb.de wrote:

> On Wednesday 09 June 2010 22:46:28 Ales Teska wrote:
>> after upgrade of Linux kernel to version 2.6.34 I started to observe =
following problem=20
>> - ppp and other serial port related application occasionally (in 1 =
hour or 1/10 ppp=20
>> connections) 'hangs' (see description bellow) rendering related =
serial device unusable.
>> I backtracked this issue to 2.6.32.15.
>> Application remains in the condition marked as 'D' in 'ps' output =
(waiting for result
>> from kernel space, if I understand that correctly); it stays in this =
condition forever.
>=20
> It would be good to find out where exactly the application hangs. =
Please try a sysrq-t
> (press Alt+SysRq+t simultaneously) or cat =
/proc/<pid-that-hangs>/stack.
>=20
> It might also be helpful to try running the kernel with CONFIG_LOCKDEP =
and/or
> CONFIG_TTY_MUTEX enabled. For the latter one, you need to get the =
source
> from the tty branch of =
git://git.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git
>=20
>> I also found following information in dmesg:
>> [ 1673.660876] ------------[ cut here ]------------
>> [ 1673.661471] WARNING: at drivers/char/tty_io.c:1278 =
tty_open+0x213/0x451()
>> [ 1673.662358] Modules linked in: ppp_deflate zlib_deflate bsd_comp =
ppp_async crc_ccitt ppp_generic slhc ipv6 nvram msr cpuid ledtrig_timer =
ledtrig_heartbeat ledtrig_default_on geodewdt lm90 hwmon scx200_acb =
option usbserial ehci_hcd ohci_hcd via_rhine usbcore leds_alix2 mii
>> [ 1673.689168] Pid: 1275, comm: ufoprobe_client Not tainted =
2.6.34-486-exiprobes #1
>> [ 1673.690452] Call Trace:
>> [ 1673.690947]  [<c10e93af>] ? tty_open+0x213/0x451
>> [ 1673.691926]  [<c1018f51>] warn_slowpath_common+0x45/0x5c
>> [ 1673.693006]  [<c1018f75>] warn_slowpath_null+0xd/0x10
>> [ 1673.694293]  [<c10e93af>] tty_open+0x213/0x451
>> [ 1673.694755]  [<c1068105>] chrdev_open+0xe3/0x126
>=20
> Do you always see this message exactly once before it hangs?
>=20
> 	Arnd


--Apple-Mail-6--592731779
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIF0jCCBc4w
ggO2oAMCAQICAwgUfjANBgkqhkiG9w0BAQUFADB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQL
ExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3Jp
dHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xMDAxMjAwMTU0NDRaFw0x
MDA3MTkwMTU0NDRaMIGgMRgwFgYDVQQDEw9DQWNlcnQgV29UIFVzZXIxHTAbBgkqhkiG9w0BCQEW
DnRlc2thQGN5YmVyLmN6MSMwIQYJKoZIhvcNAQkBFhRhbGVzLnRlc2thQGdtYWlsLmNvbTEiMCAG
CSqGSIb3DQEJARYTYWxlcy50ZXNrYUBjeWJlci5jejEcMBoGCSqGSIb3DQEJARYNYWxleEBjeWJl
ci5jejCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANDeFSDQiduIqebNe6WvB/J9LOV3
jZSrU/f0Vod183Ak6RY3JudJiCft9tbIn/qmeh9n3jswspjZ8JGT939xEc819w5nvojch3kz7fIZ
jVzJbj8VVaL0dz6QpPEHu1d/0U8i+rBYs1DFvFasulLKjW75i/S7IhxjimX9r64Qx/Q1kYwMVZ8Y
6SFsZT1h7EZ+/ndkUUbfF7NQxwtB+xcKwNYSyO3bwgwZnNCu68NNiJQRL6S946EoNVSKJWd0e/ZY
44BhIjSlTxcx1/qgwnTT6dh2IJAFGbw91WAW8iPa262SyJ44GoljLz0IV17+ryFPs/NKK380p++G
RkkWROj56y0CAwEAAaOCATUwggExMAwGA1UdEwEB/wQCMAAwVgYJYIZIAYb4QgENBEkWR1RvIGdl
dCB5b3VyIG93biBjZXJ0aWZpY2F0ZSBmb3IgRlJFRSBoZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5D
QWNlcnQub3JnMEAGA1UdJQQ5MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYB
BAGCNwoDAwYJYIZIAYb4QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29j
c3AuY2FjZXJ0Lm9yZzBTBgNVHREETDBKgQ50ZXNrYUBjeWJlci5jeoEUYWxlcy50ZXNrYUBnbWFp
bC5jb22BE2FsZXMudGVza2FAY3liZXIuY3qBDWFsZXhAY3liZXIuY3owDQYJKoZIhvcNAQEFBQAD
ggIBAJ1/tqFKObMtLCLj55BlXh5kP7I2RBUNuQBpdnb/f8655yEP+kGww/QwF1DUs7Q/q/Z7U13D
jTooB+GrpI8nZfvtI4EnrpQPWO1tclRwQYcloPoq7lbWKv1vb7Fufhq3RXabrYhmPOwsTJ6j4K9b
M8JfW0DPW0S9CSFgCR8y1C57J4+t6P2heoTnuIrCP0Y1I1fkX5Egce/eRjKsW2EY7HuxRs3Rn2Dj
2QKPft1tpf8JdgD8K6PMzatyAWOpGdU0RuS3+hsBunVz/6UXlBNpqk2brrVLnYHEAovDya/rPdqq
L9MShHNBoNOykivihCVUIM0GPtNYHbTfQEc2mWLayWtJGdBl0h9jFocnkN26JrdZgZvz2+LOQdjN
KnwvhdIZwkujqlnn5S6mbKLOlQKT6wgJzA0FIxYXgLU32lygfL017ID2V6uju8+y6H0svEeh4bQ1
+7seeoTlbv8r314ZHBhZfS0voVeAX8CIM1rQjmGeC9dh7X9ihSotAKR0HmZnVtqOtZVXToMeNrFB
HlbZhf0G3UiNKji5wbr7gYghB1dwps8b3m6KTQcPV3hO2BvmHpYZFdie5TeMIMxn23ID8n1ZlSos
LKquRSFJSsHAarDpCxHt/c2By0k4vwwQCWlOwdGQCzBmS7CPj+BiN+6qChYrxFu8i1xZUuQ17/8f
j86/MYIDMzCCAy8CAQEwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3
dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZI
hvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAwgUfjAJBgUrDgMCGgUAoIIBhzAYBgkqhkiG9w0B
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMDA2MTEwMDA0NTVaMCMGCSqGSIb3DQEJ
BDEWBBTCVbSjb+0dnXDgvE95zE4SpUb0DDCBkQYJKwYBBAGCNxAEMYGDMIGAMHkxEDAOBgNVBAoT
B1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2Vy
dCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMI
FH4wgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0
dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMIFH4wDQYJKoZIhvcNAQEBBQAEggEA
vsHkRHYni0z23ZRIPqMxrLY0HeEASBxRhzthf2+By3V41M7igoB+9JxLdszYAhxbqv4WYcrhoVWH
pa7EEa26/UNb/mQv/WPpCUEH7zU53pPdnB1lko/Rp9OkiPI5mZ53/uszhP2y00Y1O1rk0i5ZsG4v
3TwwxApsyolYSQTAslZBuTM8Wk9Ww39sCZ/L4y5EQHC+GGurf940okKTKky4BPxNFnplHBhPWvCS
N8YbKGmZRp84HwaODXn8O2d3Q28TZ4ZmZq7s/AcuvsgSZLw2NaXi7uE/6RNzb/LB9OpwnX7a+VVj
bGuOvEj64qTeygEovdo+L5txM5sMJRDjVAOBnQAAAAAAAA==

--Apple-Mail-6--592731779--
