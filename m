Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab0G3Kxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 06:53:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46219 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab0G3Kxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 06:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wYn26g/mVQm+gkuFbfThJ6Oydp7QMtAKxpkW6cWiGf1K7zqdIep0cxSmHNJaSrvvua
         yW/W1dhuxjchTTmIktHngiw9mN0Oj8nOz+T25rgdYJGajgDNh+ji+jbuLfmJrAuAZ5fj
         xL3BgncZKvF6h8kA9b54rJ9aS1YNlZDzRt1nk=
MIME-Version: 1.0
In-Reply-To: <4C52A307.7080002@canonical.com>
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
	<1280440089-3203-2-git-send-email-john.johansen@canonical.com>
	<AANLkTikk3tNM-fsXuS_SeAWgaYYCFrFAToRXOBkPxwy9@mail.gmail.com>
	<4C52A307.7080002@canonical.com>
Date: Fri, 30 Jul 2010 13:53:36 +0300
X-Google-Sender-Auth: 7KLmTcNtR8iyoFLdOOVQwyXDRaY
Message-ID: <AANLkTi=mcrGTMBonxby1gR1OijPB4z072i6cNsLxNU09@mail.gmail.com>
Subject: Re: [PATCH 01/13] AppArmor: misc. base functions and defines
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, xiaosuo@gmail.com,
        laijs@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 1:01 PM, John Johansen
<john.johansen@canonical.com> wrote:
>>> +/**
>>> + * kvfree - free an allocation do by kvmalloc
>>> + * @buffer: buffer to free (MAYBE_NULL)
>>> + *
>>> + * Free a buffer allocated by kvmalloc
>>> + */
>>> +void kvfree(void *buffer)
>>> +{
>>> +       if (is_vmalloc_addr(buffer)) {
>>> +               /* Data is no longer valid so just use the allocated space
>>> +                * as the work_struct
>>> +                */
>>> +               struct work_struct *work = (struct work_struct *) buffer;
>>> +               INIT_WORK(work, do_vfree);
>>> +               schedule_work(work);
>>
>> I don't understand this part here. Is it needed for interrupt contexts
>> or does vfree() sleep somewhere? If it's for the former, I think we
>> can just add a comment saying that kvmalloc/kvfree is not safe from
>> interrupt context and remove the schedule_work() parts here.
>
> vfree can sleep, and skipping the schedule_work parts won't work for
> apparmor as many of these allocations are being freed via rcu callbacks
> as most of our object life cycles are dependent on cred refcounting.

Can someone point me to where vfree() actually sleeps? I'm unable to
find the exact spot.
