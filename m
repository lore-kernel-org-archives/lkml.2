Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477Ab1D1OTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:19:20 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47534 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1D1OTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:19:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FJOLoa+SYv0sYR8BjxHR7clVSSxDaFrKbpa1BiWZcqN2KZl/E74XuxFsS0+7gGEaJd
         xnUPq5XUFituJ5saEMPqMO5glEl0cZRJKGFLawOZzkvA8Vdbuxz/YjcAryRIZwoW4B9S
         jX+NhBuGiK8lwTOh9ypxWTMFwAcRzZBzMvmvQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTin6jguQue_0Y74jGPnmhCcvWLBjHg@mail.gmail.com>
References: <1303963358-4652-1-git-send-email-haojian.zhuang@gmail.com>
	<20110428102212.2d8d607c@endymion.delvare>
	<BANLkTin6jguQue_0Y74jGPnmhCcvWLBjHg@mail.gmail.com>
Date: Thu, 28 Apr 2011 22:19:15 +0800
Message-ID: <BANLkTikV1QdQO90DAyy045B38z9W7+bTLw@mail.gmail.com>
Subject: Re: [PATCH 1/3] i2c: append hardware lock with bus lock
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 4:36 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Thu, Apr 28, 2011 at 4:22 PM, Jean Delvare <khali@linux-fr.org> wrote:
>> Hi Haojian,
>>
>> On Thu, 28 Apr 2011 12:02:36 +0800, Haojian Zhuang wrote:
>>> Both AP and CP are contained in Marvell PXA910 silicon. These two ARM
>>> cores are sharing one pair of I2C pins.
>>>
>>> In order to keep I2C transaction operated with atomic, hardware lock
>>> (RIPC) is required. Because of this, bus lock in AP side can't afford
>>> this requirement. Now hardware lock is appended.
>>
>> I have no objection to the idea, but one question: when using the
>> hardware lock, isn't the software mutex redundant? I would expect that
>> you call the hardware_lock/unlock functions _instead_ of
>> rt_mutex_lock/unlock, rather than in addition to it. Or do you still
>> need the rt_mutex to prevent priority inversion?
>>
>
> Jean,
>
> It's actually not redundant. The hardware lock is used to protect
> access to the same register regions between two processors (AP
> and CP so called), while the software lock is used to protect
> access from within the AP side.
>

Jean,

It's not redundant. Reading RIPC register will try to get the lock. We're always
using __raw_readl() API to read register. I think the read operation
couldn't be
atomic and finished in one instruction cycle. If two processes in AP
side try to
get the RIPC lock with __raw_readl(), it may result dead lock. If we fetch the
RIPC lock behind software bus lock, it's safe.

If process on AP try to get the RIPC lock and compete with CP, it won't be an
issue. It should always be atomic.
