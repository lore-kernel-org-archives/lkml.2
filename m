Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424310Ab2LFQNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:13:32 -0500
Received: from server505c.appriver.com ([98.129.35.7]:2090 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1424049Ab2LFQNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:13:02 -0500
X-Note-AR-ScanTimeLocal: 12/6/2012 10:12:58 AM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNKNOWN->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 98.129.35.1
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G328 G329 G330 G331 G335 G336 G347 G443 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 6 Dec 2012 10:12:57 -0600
Subject: Re: [PATCH 1/7] aoe: improve handling of misbehaving network paths
Thread-Topic: [PATCH 1/7] aoe: improve handling of misbehaving network paths
Thread-Index: Ac3TzI6RRazcCa5eTn24eWSuYneFjA==
Message-ID: <3446E79A-39CB-4EDE-8C07-3CF2C698D87C@coraid.com>
References: <cover.1354501189.git.ecashin@coraid.com>
 <f7df7cd5fe1a303debe7cbf086853663e3c59366.1354501189.git.ecashin@coraid.com>
 <20121204153912.2e6b4d2f.akpm@linux-foundation.org>
In-Reply-To: <20121204153912.2e6b4d2f.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 4, 2012, at 6:39 PM, Andrew Morton wrote:

> On Mon, 3 Dec 2012 20:40:55 -0500
> Ed Cashin <ecashin@coraid.com> wrote:
...
>> +static void
>> +ata_rw_frameinit(struct frame *f)
>> +{
>> +	struct aoetgt *t;
>> +	struct aoe_hdr *h;
>> +	struct aoe_atahdr *ah;
>> +	struct sk_buff *skb;
>> +	char writebit, extbit;
>> +
>> +	skb = f->skb;
>> +	h = (struct aoe_hdr *) skb_mac_header(skb);
>> +	ah = (struct aoe_atahdr *) (h + 1);
> 
> Well.  It would be neater to have a
> 
> struct whatever {
> 	struct aoe_hdr hdr;
> 	struct aoe_atahdr atahdr;
> };

This code just moved from aoecmd_ata_rw into a function that can be 
used by both aoecmd_ata_rw() and the new probe() function, so this
"h+1" way of getting at the ATA header is not new.  I'll make a note of 
your recommendation for future new code and for cleanups.

...
>> @@ -462,11 +488,14 @@ resend(struct aoedev *d, struct frame *f)
>> 	h = (struct aoe_hdr *) skb_mac_header(skb);
>> 	ah = (struct aoe_atahdr *) (h+1);
>> 
>> -	snprintf(buf, sizeof buf,
>> -		"%15s e%ld.%d oldtag=%08x@%08lx newtag=%08x s=%pm d=%pm nout=%d\n",
>> -		"retransmit", d->aoemajor, d->aoeminor, f->tag, jiffies, n,
>> -		h->src, h->dst, t->nout);
>> -	aoechr_error(buf);
>> +	if (!(f->flags & FFL_PROBE)) {
>> +		snprintf(buf, sizeof(buf),
>> +			"%15s e%ld.%d oldtag=%08x@%08lx newtag=%08x s=%pm d=%pm nout=%d\n",
>> +			"retransmit", d->aoemajor, d->aoeminor,
>> +			f->tag, jiffies, n,
>> +			h->src, h->dst, t->nout);
>> +		aoechr_error(buf);
> 
> Could use kasprintf() here.  That avoids the fixed-size local buffer
> and avoids the GFP_ATOMIC allocation and copy in aoechr_error().

This patch doesn't change the way aoechr_error() is used.  But 
thinking about the suggestion, I see that avoiding the GFP_ATOMIC 
allocation isn't practical here, because resend() is called after 
spin_lock_irq().  Let me know if you still think it would be worth 
cleaning up.  It could go on the todo list.

...
>> aoecmd_init(void)
>> {
>> +	void *p;
>> +
>> +	/* get_zeroed_page returns page with ref count 1 */
>> +	p = (void *) get_zeroed_page(GFP_KERNEL | __GFP_REPEAT);
>> +	if (!p)
>> +		return -ENOMEM;
>> +	empty_page = virt_to_page(p);
> 
> Could use alloc_pages() and remove `p' and the virt_to_page().
> 
> Why is __GFP_REPEAT used?  I don't think this __init function is more
> important than all the other ones in the kernel?

I think you are not implying that it's hurting the rest of the kernel for
__GFP_REPEAT to be used here but that you mean the aoe driver's
initialization should behave like the other initialization code in the 
kernel, and nobody else is using __GFP_REPEAT, so aoe should 
follow suit.  Please let me know if I'm misinterpreting your feedback.

Anyway, it's fine with me if you want to remove __GFP_REPEAT, or
I can resubmit this patch without it if you prefer.

-- 
  Ed Cashin
  ecashin@coraid.com


