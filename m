Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab1ERLLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:11:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58193 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763Ab1ERLLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:11:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hsBaffc1KHrZoS57piMKc1itUdg1XHRWSeNTdFn78DmclkKZf1JMCT6V6hk1wxK72w
         GlU2jwv3gn+iIBgN6KmUgl6fe2My/2QeoDeiAnPxx2zzCbTxdoNmMuceEwGbY6zHPFP0
         9crSQ8O4vIGYHPE8x7Wwa4sHWsdk0wf2ufrFg=
MIME-Version: 1.0
In-Reply-To: <20110518103819.GL7589@redhat.com>
References: <1305574128.3456.23.camel@localhost.localdomain>
 <1305574518.2885.25.camel@bwh-desktop> <1305574680.3456.33.camel@localhost.localdomain>
 <1305575253.2885.28.camel@bwh-desktop> <20110516211459.GE18148@redhat.com>
 <1305588738.3456.65.camel@localhost.localdomain> <BANLkTimvOK3tyo6+L5AD=so5DjiDPV-AAA@mail.gmail.com>
 <1305671318.10756.49.camel@localhost.localdomain> <20110518103819.GL7589@redhat.com>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Wed, 18 May 2011 13:10:50 +0200
Message-ID: <BANLkTimc1RbC3uQsra1HUvS_Trg63iMWGA@mail.gmail.com>
Subject: Re: [PATCH V5 2/6 net-next] netdevice.h: Add zero-copy flag in netdevice
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Shirley Ma <mashirle@us.ibm.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/18 Michael S. Tsirkin <mst@redhat.com>:
> On Tue, May 17, 2011 at 03:28:38PM -0700, Shirley Ma wrote:
>> On Tue, 2011-05-17 at 23:48 +0200, Micha³ Miros³aw wrote:
>> > 2011/5/17 Shirley Ma <mashirle@us.ibm.com>:
>> > > Hello Michael,
>> > >
>> > > Looks like to use a new flag requires more time/work. I am thinking
>> > > whether we can just use HIGHDMA flag to enable zero-copy in macvtap
>> > to
>> > > avoid the new flag for now since mavctap uses real NICs as lower
>> > device?
>> >
>> > Is there any other restriction besides requiring driver to not recycle
>> > the skb? Are there any drivers that recycle TX skbs?
>
> Not just recycling skbs, keeping reference to any of the pages in the
> skb. Another requirement is to invoke the callback
> in a timely fashion.  For example virtio-net doesn't limit the time until
> that happens (skbs are only freed when some other packet is
> transmitted), so we need to avoid zcopy for such (nested-virt)
> scenarious, right?

Hmm. But every hardware driver supporting SG will keep reference to
the pages until the packet is sent (or DMA'd to the device). This can
take a long time if hardware queue happens to stall for some reason.

Is it that you mean keeping a reference after all skbs pointing to the
pages are released?

>> Not more other restrictions, skb clone is OK. pskb_expand_head() looks
>> OK to me from code review.
> Hmm. pskb_expand_head calls skb_release_data while keeping
> references to pages. How is that ok? What do I miss?

It's making copy of the skb_shinfo earlier, so the pages refcount
stays the same.

Best Regards,
Micha³ Miros³aw
