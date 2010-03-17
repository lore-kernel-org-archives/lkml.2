Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0CQSkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 14:40:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35857 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab0CQSks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 14:40:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ss5ZkjPZu1TUtayga0WMkGLNPzb/BR6usz6+PVVW1+SBIuTsfAD67fLj7UYzHsKT9
	TDv3Fcu8PTiSI8RzdESKQ==
MIME-Version: 1.0
In-Reply-To: <97949e3e1003171054q3bee27d5yce0d92ae33e5b5ca@mail.gmail.com>
References: <20100317144249.GA3984@redhat.com> <97949e3e1003171054q3bee27d5yce0d92ae33e5b5ca@mail.gmail.com>
From: Laurent Chavey <chavey@google.com>
Date: Wed, 17 Mar 2010 11:40:23 -0700
Message-ID: <97949e3e1003171140j530ead98k40edd8eb647a0399@mail.gmail.com>
Subject: Re: [PATCH] vhost: fix error handling in vring ioctls
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Laurent Chavey <chavey@google.com>

On Wed, Mar 17, 2010 at 10:54 AM, Laurent Chavey <chavey@google.com> wrote:
> Acked-by: chavey@google.com
>
>
> On Wed, Mar 17, 2010 at 7:42 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
>> Stanse found a locking problem in vhost_set_vring:
>> several returns from VHOST_SET_VRING_KICK, VHOST_SET_VRING_CALL,
>> VHOST_SET_VRING_ERR with the vq->mutex held.
>> Fix these up.
>>
>> Reported-by: Jiri Slaby <jirislaby@gmail.com>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> ---
>>  drivers/vhost/vhost.c |   18 ++++++++++++------
>>  1 files changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 7cd55e0..7bd7a1e 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -476,8 +476,10 @@ static long vhost_set_vring(struct vhost_dev *d, int ioctl, void __user *argp)
>>                if (r < 0)
>>                        break;
>>                eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
>> -               if (IS_ERR(eventfp))
>> -                       return PTR_ERR(eventfp);
>> +               if (IS_ERR(eventfp)) {
>> +                       r = PTR_ERR(eventfp);
>> +                       break;
>> +               }
>>                if (eventfp != vq->kick) {
>>                        pollstop = filep = vq->kick;
>>                        pollstart = vq->kick = eventfp;
>> @@ -489,8 +491,10 @@ static long vhost_set_vring(struct vhost_dev *d, int ioctl, void __user *argp)
>>                if (r < 0)
>>                        break;
>>                eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
>> -               if (IS_ERR(eventfp))
>> -                       return PTR_ERR(eventfp);
>> +               if (IS_ERR(eventfp)) {
>> +                       r = PTR_ERR(eventfp);
>> +                       break;
>> +               }
>>                if (eventfp != vq->call) {
>>                        filep = vq->call;
>>                        ctx = vq->call_ctx;
>> @@ -505,8 +509,10 @@ static long vhost_set_vring(struct vhost_dev *d, int ioctl, void __user *argp)
>>                if (r < 0)
>>                        break;
>>                eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
>> -               if (IS_ERR(eventfp))
>> -                       return PTR_ERR(eventfp);
>> +               if (IS_ERR(eventfp)) {
>> +                       r = PTR_ERR(eventfp);
>> +                       break;
>> +               }
>>                if (eventfp != vq->error) {
>>                        filep = vq->error;
>>                        vq->error = eventfp;
>> --
>> 1.7.0.18.g0d53a5
>> --
>> To unsubscribe from this list: send the line "unsubscribe netdev" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
