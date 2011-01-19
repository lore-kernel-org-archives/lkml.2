Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab1ASRot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:44:49 -0500
Received: from mail-yi0-f42.google.com ([209.85.218.42]:59991 "EHLO
	mail-yi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab1ASRor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:44:47 -0500
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jan 2011 12:44:47 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sR54sCvZE58S33swd4/uIm6VhDqGQDJ029H9ZsXSkXTjYX1Wy+MRew8sXlhGTunQOH
         ui7uCk1Z7b3d7I5SDjV+GC9mfRml7Og5EtpWd2kELxn6IWkVJL3PLcupLvyv1cVB9toB
         KGPjbUnRRaJ6ccfE8uM6OZb/JJ8HSqTIrAZQI=
MIME-Version: 1.0
In-Reply-To: <20110119165011.GA16682@quack.suse.cz>
References: <x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
	<AANLkTimuCgn4aHzUJRmQfsXjG_UF-3W8fAWb0Y-sSPsM@mail.gmail.com>
	<x49tyh7mjr6.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikgsGHJ+q6=We_zPAivyABq+z2f6Atv6ZScLYOU@mail.gmail.com>
	<20110118190114.GA5070@quack.suse.cz>
	<AANLkTin1+B_1CV-weALdS8EYJO60BJd0b7AGWzc0wrWr@mail.gmail.com>
	<20110118235236.GA14087@quack.suse.cz>
	<AANLkTikvCkMDM9+i=44eEkX094=ZHpnQaN+541pm1icK@mail.gmail.com>
	<20110119132123.GC4246@quack.suse.cz>
	<AANLkTi=Z0eyXBkWL6YYdUVzA16hs=WjC7u=wfEHzAozC@mail.gmail.com>
	<20110119165011.GA16682@quack.suse.cz>
Date: Thu, 20 Jan 2011 04:37:55 +1100
Message-ID: <AANLkTikqwy_-0-8J5_UcBrS+ukA67cz791XxChsNPZOf@mail.gmail.com>
Subject: Re: [patch] fs: aio fix rcu lookup
From: Nick Piggin <npiggin@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 3:50 AM, Jan Kara <jack@suse.cz> wrote:
> On Thu 20-01-11 03:03:23, Nick Piggin wrote:
>> On Thu, Jan 20, 2011 at 12:21 AM, Jan Kara <jack@suse.cz> wrote:
>> >  Well, we are not required to cancel all the outstanding AIO because of the
>> > API requirement, that's granted. But we must do it because of the way how
>> > the code is written. Outstanding IO requests reference ioctx but they are
>> > not counted in ctx->users but in ctx->reqs_active. So the code relies on
>> > the fact that the reference held by the hash table protects ctx from being
>> > freed and io_destroy() waits for requests before dropping the last
>> > reference to ctx. But there's the second race I describe making it possible
>> > for new IO to be created after io_destroy() has waited for all IO to
>> > finish...
>>
>> Yes there is that race too I agree. I just didn't follow through the code far
>> enough to see it was a problem -- I thought it was by design.
>>
>> I'd like to solve it without synchronize_rcu() though.
>  Ah, OK. I don't find io_destroy() performance critical but I can

Probably not performance critical, but it could be a very
large slowdown so somebody might complain.

> understand that you need not like synchronize_rcu() there. ;) Then it
> should be possible to make IO requests count in ctx->users which would
> solve the race as well. We'd just have to be prepared that request
> completion might put the last reference to ioctx and free it but that
> shouldn't be an issue. Do you like that solution better?

I think so, if it can be done without slowing things down
and adding locks or atomics if possible.
