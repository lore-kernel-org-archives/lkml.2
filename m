Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2HBJ20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 05:28:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41009 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2HBJ2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 05:28:25 -0400
MIME-Version: 1.0
In-Reply-To: <1343897839.5073.7.camel@dabdike.int.hansenpartnership.com>
References: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com>
	<1343897839.5073.7.camel@dabdike.int.hansenpartnership.com>
Date: Thu, 2 Aug 2012 18:28:21 +0900
Message-ID: <CAOAMb1C=fk_Ejm6TwOhoNLhP1TyRJ+QVi93VaqUmxoHsM1iXtQ@mail.gmail.com>
Subject: Re: [PATCH] fix NULL-pointer dereference on scsi_run_queue
From: Chanho Min <chanho0207@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 2, 2012 at 5:57 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2012-08-02 at 17:41 +0900, Chanho Min wrote:
>> This patch is to fix a oops from a torn down device. When
>> scsi_run_queue process starved queues, scsi_request_fn can race with
>> scsi_remove_device. In this case, rarely, scsi_request_fn release the
>> last reference and set sdev->request_queue to NULL. It result in
>> NULL-pointer dereference when spin_unlock is tried with (NULL)->
>> queue_lock. We need to add an extra reference to the device on both
>> sides of the __blk_run_queue to hold reference until scsi_request_fn
>> is finished.
>
> You need a recent kernel with this patch:
>
> commit 940f5d47e2f2e1fa00443921a0abf4822335b54d
> Author: Bart Van Assche <bvanassche@acm.org>
> Date:   Fri Jun 29 15:34:26 2012 +0000
>
>     [SCSI] Avoid dangling pointer in scsi_requeue_command()
>
> James
It is different from my case. This is occured inside scsi_run_queue
and on processing starved_list.
Another sdev is obtained from starved_list.
