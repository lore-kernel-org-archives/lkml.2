Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1AWTGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 14:06:39 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:44347 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab1AWTGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 14:06:38 -0500
Message-ID: <4D3C7C36.903@free.fr>
Date: Sun, 23 Jan 2011 20:06:30 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX protection
 for kernel data)
References: <1290410581.2405.24.camel@minggr.sh.intel.com>	 <1290431008.2072.119.camel@laptop>	<1290443379.4cea9a73cd9ce@imp.free.fr>	 <1290443758.2072.318.camel@laptop>	<20101122164247.GC21836@basil.fritz.box>	 <20101123235527.54293b59@mat-laptop>  <20101126183144.300a71a4@mat-laptop>	 <1291093230.2405.191.camel@minggr.sh.intel.com>	 <1291116438.32004.649.camel@laptop> <1291162504.2405.216.camel@minggr.sh.intel.com>
In-Reply-To: <1291162504.2405.216.camel@minggr.sh.intel.com>
Content-Type: multipart/mixed;
 boundary="------------070001030305010307000803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070001030305010307000803
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Lin Ming a écrit :
> On Tue, 2010-11-30 at 19:27 +0800, Peter Zijlstra wrote:
>> On Tue, 2010-11-30 at 13:00 +0800, Lin Ming wrote:
>>> echo 0 > /sys/devices/system/cpu/cpu1/online;
>>> echo 1 > /sys/devices/system/cpu/cpu1/online;
>>>
>>> then machine just reboots...
>>>
I tried to do the same thing on qemu, and the same behavior happened (ie reboot when resuming cpu1).

After enabling qemu log, I found that a triple fault was happening at the beginning of secondary_startup_64
when doing "addq phys_base(%rip), %rax".

Why ?
I suppose because we access data set to NX, but we don't have enabled yet NX in the msr. So the cpu crash due 
to "reserved bit check".

If we enable NX before reading data, there is no more crash (patch attached).

Now I am not sure this is the correct fix. I think the problem is that trampoline using kernel page table
is very dangerous. The kernel can have modified them atfer booting !
May be all the paging stuff should have been done in head_64.S. A first one with identity mapping, and the second one for
the real kernel stuff.


Matthieu

--------------070001030305010307000803
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="diff"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9oZWFkXzY0LlMgYi9hcmNoL3g4Ni9rZXJu
ZWwvaGVhZF82NC5TCmluZGV4IDIzOTA0NmIuLjlmMzIyOTUgMTAwNjQ0Ci0tLSBhL2FyY2gv
eDg2L2tlcm5lbC9oZWFkXzY0LlMKKysrIGIvYXJjaC94ODYva2VybmVsL2hlYWRfNjQuUwpA
QCAtMTY1LDE2ICsxNjUsNiBAQCBFTlRSWShzZWNvbmRhcnlfc3RhcnR1cF82NCkKIAltb3Zs
CSQoWDg2X0NSNF9QQUUgfCBYODZfQ1I0X1BHRSksICVlYXgKIAltb3ZxCSVyYXgsICVjcjQK
IAotCS8qIFNldHVwIGVhcmx5IGJvb3Qgc3RhZ2UgNCBsZXZlbCBwYWdldGFibGVzLiAqLwot
CW1vdnEJJChpbml0X2xldmVsNF9wZ3QgLSBfX1NUQVJUX0tFUk5FTF9tYXApLCAlcmF4Ci0J
YWRkcQlwaHlzX2Jhc2UoJXJpcCksICVyYXgKLQltb3ZxCSVyYXgsICVjcjMKLQotCS8qIEVu
c3VyZSBJIGFtIGV4ZWN1dGluZyBmcm9tIHZpcnR1YWwgYWRkcmVzc2VzICovCi0JbW92cQkk
MWYsICVyYXgKLQlqbXAJKiVyYXgKLTE6Ci0KIAkvKiBDaGVjayBpZiBueCBpcyBpbXBsZW1l
bnRlZCAqLwogCW1vdmwJJDB4ODAwMDAwMDEsICVlYXgKIAljcHVpZApAQCAtMTg5LDYgKzE3
OSwxNyBAQCBFTlRSWShzZWNvbmRhcnlfc3RhcnR1cF82NCkKIAlidHNsCSRfRUZFUl9OWCwg
JWVheAogMToJd3Jtc3IJCQkJLyogTWFrZSBjaGFuZ2VzIGVmZmVjdGl2ZSAqLwogCisJLyog
U2V0dXAgZWFybHkgYm9vdCBzdGFnZSA0IGxldmVsIHBhZ2V0YWJsZXMuICovCisJbW92cQkk
KGluaXRfbGV2ZWw0X3BndCAtIF9fU1RBUlRfS0VSTkVMX21hcCksICVyYXgKKwlhZGRxCXBo
eXNfYmFzZSglcmlwKSwgJXJheAorCW1vdnEJJXJheCwgJWNyMworCisJLyogRW5zdXJlIEkg
YW0gZXhlY3V0aW5nIGZyb20gdmlydHVhbCBhZGRyZXNzZXMgKi8KKwltb3ZxCSQxZiwgJXJh
eAorCWptcAkqJXJheAorMToKKworCiAJLyogU2V0dXAgY3IwICovCiAjZGVmaW5lIENSMF9T
VEFURQkoWDg2X0NSMF9QRSB8IFg4Nl9DUjBfTVAgfCBYODZfQ1IwX0VUIHwgXAogCQkJIFg4
Nl9DUjBfTkUgfCBYODZfQ1IwX1dQIHwgWDg2X0NSMF9BTSB8IFwK
--------------070001030305010307000803--
