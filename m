Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2BPUl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:41:58 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:30330
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349Ab2BPUl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:41:56 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F3D6A0E.4080705@freescale.com>
Date: Thu, 16 Feb 2012 14:41:50 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, Anthony Liguori <anthony@codemonkey.ws>,
        KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de> <4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de> <4F313354.4080401@redhat.com> <4B03190C-1B6B-48EC-92C7-C27F6982018A@suse.de> <4F3B9497.4020700@redhat.com> <C2015C96-C4B7-4768-8C01-E41F4D8ED9FB@suse.de> <4F3BB33C.1000908@redhat.com> <1FE08D00-49E8-4371-9F23-C5D2EE568FA8@suse.de> <4F3BB9DC.6040102@redhat.com> <3DC824A5-5D5A-4BCC-A0FB-1B459B7E362D@suse.de> <4F3D57E3.7020503@redhat.com> <810F6879-64A9-4FCF-9C22-00BCC945D6B0@suse.de> <4F3D5B35.4000606@redhat.com>
In-Reply-To: <4F3D5B35.4000606@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 01:38 PM, Avi Kivity wrote:
> On 02/16/2012 09:34 PM, Alexander Graf wrote:
>> On 16.02.2012, at 20:24, Avi Kivity wrote:
>>
>>> On 02/15/2012 04:08 PM, Alexander Graf wrote:
>>>>>
>>>>> Well, the scatter/gather registers I proposed will give you just one
>>>>> register or all of them.
>>>>
>>>> One register is hardly any use. We either need all ways of a respective address to do a full fledged lookup or all of them. 
>>>
>>> I should have said, just one register, or all of them, or anything in
>>> between.
>>>
>>>> By sharing the same data structures between qemu and kvm, we actually managed to reuse all of the tcg code for lookups, just like you do for x86.
>>>
>>> Sharing the data structures is not need.  Simply synchronize them before
>>> lookup, like we do for ordinary registers.
>>
>> Ordinary registers are a few bytes. We're talking of dozens of kbytes here.
> 
> A TLB way is a few dozen bytes, no?

I think you mean a TLB set... but the TLB (or part of it) may be fully
associative.

On e500mc, it's 24 bytes for one TLB entry, and you'd need 4 entries for
a set of TLB0, and all 64 entries in TLB1.  So 1632 bytes total.

Then we'd need to deal with tracking whether we synchronized one or more
specific sets, or everything (for migration or debug TLB dump).  The
request to synchronize would have to come from within the QEMU MMU code,
since that's the point where we know what to ask for (unless we
duplicate the logic elsewhere).  I'm not sure that reusing the standard
QEMU MMU code for individual debug address translation is really
simplifying things...

And yes, we do have fancier hardware coming fairly soon for which this
breaks (TLB0 entries can be loaded without host involvement, as long as
there's a translation from guest physical to physical in a separate
hardware table).  It'd be reasonable to ignore TLB0 for migration (treat
it as invalidated), but not for debug since that may be where the
translation we're interested in resides.

-Scott

