Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab1ASI56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 03:57:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37039 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab1ASI55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 03:57:57 -0500
Message-ID: <4D36A759.60704@intel.com>
Date: Wed, 19 Jan 2011 00:56:57 -0800
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
Organization: Intel Corporation
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Lu, Hongjiu" <hongjiu.lu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Linux 2.6.38-rc1 doesn't boot
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>	 <20110119073905.GA1652@gentoo.trippels.de>	 <20110119074902.GA1670@gentoo.trippels.de> <1295424766.1949.879.camel@sli10-conroe>
In-Reply-To: <1295424766.1949.879.camel@sli10-conroe>
Content-Type: multipart/mixed;
 boundary="------------070705050300040201040108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070705050300040201040108
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/19/2011 12:12 AM, Shaohua Li wrote:
> On Wed, 2011-01-19 at 15:49 +0800, Markus Trippelsdorf wrote:
>> On 2011.01.19 at 08:39 +0100, Markus Trippelsdorf wrote:
>>> On 2011.01.18 at 15:54 -0800, Linus Torvalds wrote:
>>>>
>>>> And as usual, report any regressions to the lists and the appropriate
>>>> authorities.
>>>
>>> Unfortunately 2.6.38-rc1 doesn't even boot on my machine (amd64).
>>> This is caused by 86b1e8dd83cbb0f:
>>>     x86: Make relocatable kernel work with new binutils
>>>
>>> Reverting the commit solves the problem.
>>
>> I'm running the latest binutils:
>> GNU ld (Linux/GNU Binutils) 2.21.51.0.5.20110104
> Hmm, reproduce it here with binutils-2.21.51.0.6-20110118
> but not with GNU ld (GNU Binutils for Ubuntu) 2.20.51-system.20100908
> I got this in system.map: ffffffff03514880 D jiffies_64, which looks
> wrong.
> looks binutils changed something again.
> Have no idea, CC Lu Hongjiu.
> 

Either way... the whole jiffies vs jiffies_64 thing is kind of
ridiculous.  We should be able to do it in a completely
architecture-generic way by either making it a union(!) (with "jiffies"
and "jiffies_64" presumably would be #defines, or we do a global replace
across the tree), moving the variable declaration itself to a .S file
(which would only have data components and therefore would be
arch-generic) or doing something like the attached (untested since it is
1 am here) patch.

This should let us get rid of the hacks in *all* the architectures, not
just x86.

	-hpa

--------------070705050300040201040108
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff"

ZGlmZiAtLWdpdCBhL2tlcm5lbC90aW1lci5jIGIva2VybmVsL3RpbWVyLmMKaW5kZXggNDNj
YTk5My4uY2I0ZGI0NyAxMDA2NDQKLS0tIGEva2VybmVsL3RpbWVyLmMKKysrIGIva2VybmVs
L3RpbWVyLmMKQEAgLTQxLDYgKzQxLDcgQEAKICNpbmNsdWRlIDxsaW51eC9zY2hlZC5oPgog
I2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KIAorI2luY2x1ZGUgPGFzbS9ieXRlb3JkZXIuaD4K
ICNpbmNsdWRlIDxhc20vdWFjY2Vzcy5oPgogI2luY2x1ZGUgPGFzbS91bmlzdGQuaD4KICNp
bmNsdWRlIDxhc20vZGl2NjQuaD4KQEAgLTU0LDYgKzU1LDEyIEBAIHU2NCBqaWZmaWVzXzY0
IF9fY2FjaGVsaW5lX2FsaWduZWRfaW5fc21wID0gSU5JVElBTF9KSUZGSUVTOwogCiBFWFBP
UlRfU1lNQk9MKGppZmZpZXNfNjQpOwogCisjaWYgZGVmaW5lZChfX0xJVFRMRV9FTkRJQU4p
IHx8IChCSVRTX1BFUl9MT05HID49IDY0KQorYXNtKCJqaWZmaWVzID0gamlmZmllc182NCIp
OworI2Vsc2UKK2FzbSgiamlmZmllcyA9IGppZmZpZXNfNjQgKyA0Iik7CisjZW5kaWYKKwog
LyoKICAqIHBlci1DUFUgdGltZXIgdmVjdG9yIGRlZmluaXRpb25zOgogICovCg==
--------------070705050300040201040108--
