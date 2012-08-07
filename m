Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab2HGJae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:30:34 -0400
Received: from relay03ant.iops.be ([212.53.5.218]:54022 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab2HGJac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:30:32 -0400
Message-ID: <5020E031.9080406@acm.org>
Date: Tue, 07 Aug 2012 09:30:25 +0000
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Chanho Min <chanho0207@gmail.com>
CC: Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] fix NULL-pointer dereference on scsi_run_queue
References: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com> <501CE4E5.20604@acm.org> <501D51D1.2010806@cs.wisc.edu> <501D83A1.7040900@acm.org> <501DA3F0.4090009@cs.wisc.edu> <50200561.4020100@acm.org> <CAOAMb1BWWzYPSode-6Y9+O5eNhMc-bYofCNwMRmzeC9-nhRb4g@mail.gmail.com>
In-Reply-To: <CAOAMb1BWWzYPSode-6Y9+O5eNhMc-bYofCNwMRmzeC9-nhRb4g@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/12 08:53, Chanho Min wrote:
> On Tue, Aug 7, 2012 at 2:56 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>> Indeed. How about the patch below ? Scsi devices are removed from
>> starved_list after blk_cleanup_queue() and before put_device(). That
>> guarantees that inside scsi_run_queue() get_device() under host lock
>> will succeed.
>
> Thanks, IMHO, it's harmless and the simple way to solve this issue.
> But, I think the second half of your patches are not required, extra
> referecne is might suffice?

I'm afraid that without the second half of that patch the following race
is still possible:
- sdev reference count drops to zero while scsi_run_queue() is in
  progress and while that sdev is on the starved_list of its SCSI host;
  scsi_device_dev_release_usercontext() call is scheduled but not yet
  executed.
- scsi_run_queue() takes that sdev off the local starved_list.
- scsi_run_queue() calls get_device() and that call fails since the
  sdev reference count is zero.
- scsi_device_dev_release_usercontext() gets scheduled and frees the
  sdev.
- scsi_run_queue() proceeds and calls __blk_run_queue() on a freed
  queue, which is what we were trying to avoid.

Bart.
