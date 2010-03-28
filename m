Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0C1B3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 21:29:17 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:42210 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab0C1B3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 21:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=nuswd/tD3WInnpiW3eQHe4mJ9biW/RSEY7Vu5uGWJy4wIuj25S4+5PTd9V+Zu7y1th
         w75K1Cjo6toX/Q8ufEyRSGrxYdoyEPB2dVMkGd6KJv6UYdHYV6P096x8L6b4Z+iVhRRl
         wVOr9+QCO4P1NNUbGv1feK+/hwQ9OCtsXvcJY=
Message-ID: <4baeb0ea.9653f10a.4c8d.5d92@mx.google.com>
Date: Sat, 27 Mar 2010 18:29:14 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, npiggin@suse.de, mingo@elte.hu,
       Ruald Andreae <ruald.a@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Olly Betts <olly@survex.com>, martin f krafft <madduck@madduck.net>
In-Reply-To: <4baeaee5.c5c2f10a.7187.2688@mx.google.com>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
	<4baeaee5.c5c2f10a.7187.2688@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Mar 2010 18:20:37 -0700 (PDT), Ben Gamari <bgamari.foss@gmail.com> wrote:
> Hey all,
> 
> I have posted another profile[1] from an incident yesterday. As you can see,
> both swapper and init (strange?) show up prominently in the profile. Moreover,
> most processes seem to be in blk_peek_request a disturbingly large percentage
> of the time. Both of these profiles were taken with 2.6.34-rc kernels.
> 

Apparently my initial email announcing my first set of profiles never made it
out. Sorry for the confusion. I've included it below.


From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, Olly Betts
	<olly@survex.com>, martin f krafft <madduck@madduck.net>
Bcc: bgamari@gmail.com
In-Reply-To: <20100317093704.GA17146@elte.hu>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
	<20100317045350.GA2869@laptop> <20100317093704.GA17146@elte.hu>
On Wed, 17 Mar 2010 10:37:04 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> A call-graph profile will show the precise reason for IO latencies, and their 
> relatively likelihood.

Well, here is something for now. I'm not sure how valid the reproduction
workload is (git pull, rsync, and 'notmuch new' all running at once), but I
certainly did produce a few stalls and swapper is highest on the profile.
This was on 2.6.34-rc2. I've included part of the profile below, although more
complete set of data is available at [1].

Thanks,

- Ben


[1] http://mw0.mooo.com/~ben/latency-2010-03-25-a/


# Samples: 25295
#
# Overhead          Command      Shared Object  Symbol
# ........  ...............  .................  ......
#
    24.50%          swapper  [kernel.kallsyms]  [k] blk_peek_request
                    |
                    --- blk_peek_request
                        scsi_request_fn
                        __blk_run_queue
                       |          
                       |--98.32%-- blk_run_queue
                       |          scsi_run_queue
                       |          scsi_next_command
                       |          scsi_io_completion
                       |          scsi_finish_command
                       |          scsi_softirq_done
                       |          blk_done_softirq
                       |          __do_softirq
                       |          call_softirq
                       |          do_softirq
                       |          irq_exit
                       |          |          
                       |          |--99.56%-- do_IRQ
                       |          |          ret_from_intr
                       |          |          |          
                       |          |          |--98.02%-- cpuidle_idle_call
                       |          |          |          cpu_idle
                       |          |          |          rest_init
                       |          |          |          start_kernel
                       |          |          |          x86_64_start_reservations
                       |          |          |          x86_64_start_kernel
                       |          |          |          
                       |          |          |--0.91%-- clockevents_notify
                       |          |          |          lapic_timer_state_broadcast
                       |          |          |          |          
                       |          |          |          |--83.64%-- acpi_idle_enter_bm
                       |          |          |          |          cpuidle_idle_call
                       |          |          |          |          cpu_idle
                       |          |          |          |          rest_init
                       |          |          |          |          start_kernel
                       |          |          |          |          x86_64_start_reservations
                       |          |          |          |          x86_64_start_kernel
                       |          |          |          |          
                       |          |          |           --16.36%-- acpi_idle_enter_simple
                       |          |          |                     cpuidle_idle_call
                       |          |          |                     cpu_idle
                       |          |          |                     rest_init
                       |          |          |                     start_kernel
                       |          |          |                     x86_64_start_reservations
                       |          |          |                     x86_64_start_kernel
                       |          |          |          
                       |          |          |--0.81%-- cpu_idle
                       |          |          |          rest_init
                       |          |          |          start_kernel
                       |          |          |          x86_64_start_reservations
                       |          |          |          x86_64_start_kernel
                       |          |           --0.26%-- [...]
                       |           --0.44%-- [...]
                       |          
                        --1.68%-- elv_completed_request
                                  __blk_put_request
                                  blk_finish_request
                                  blk_end_bidi_request
                                  blk_end_request
                                  scsi_io_completion
                                  scsi_finish_command
                                  scsi_softirq_done
                                  blk_done_softirq
                                  __do_softirq
                                  call_softirq
                                  do_softirq
                                  irq_exit
                                  do_IRQ
                                  ret_from_intr
                                  |          
                                  |--96.15%-- cpuidle_idle_call
                                  |          cpu_idle
                                  |          rest_init
                                  |          start_kernel
                                  |          x86_64_start_reservations
                                  |          x86_64_start_kernel
                                  |          
                                  |--1.92%-- cpu_idle
                                  |          rest_init
                                  |          start_kernel
                                  |          x86_64_start_reservations
                                  |          x86_64_start_kernel
                                  |          
                                  |--0.96%-- schedule
                                  |          cpu_idle
                                  |          rest_init
                                  |          start_kernel
                                  |          x86_64_start_reservations
                                  |          x86_64_start_kernel
                                  |          
                                   --0.96%-- clockevents_notify
                                             lapic_timer_state_broadcast
                                             acpi_idle_enter_bm
                                             cpuidle_idle_call
                                             cpu_idle
                                             rest_init
                                             start_kernel
                                             x86_64_start_reservations
                                             x86_64_start_kernel

    23.74%             init  [kernel.kallsyms]  [k] blk_peek_request
                       |
                       --- blk_peek_request
                           scsi_request_fn
                           __blk_run_queue
                          |          
                          |--98.77%-- blk_run_queue
                          |          scsi_run_queue
                          |          scsi_next_command
                          |          scsi_io_completion
                          |          scsi_finish_command
                          |          scsi_softirq_done
                          |          blk_done_softirq
                          |          __do_softirq
                          |          call_softirq
                          |          do_softirq
                          |          irq_exit
                          |          |          
                          |          |--99.87%-- do_IRQ
                          |          |          ret_from_intr
                          |          |          |          
                          |          |          |--98.38%-- cpuidle_idle_call
                          |          |          |          cpu_idle
                          |          |          |          start_secondary
                          |          |          |          
                          |          |          |--0.81%-- schedule
                          |          |          |          cpu_idle
                          |          |          |          start_secondary
                          |          |          |          
                          |          |          |--0.56%-- cpu_idle
                          |          |          |          start_secondary
                          |          |           --0.25%-- [...]
                          |           --0.13%-- [...]
                          |          
                           --1.23%-- elv_completed_request
                                     __blk_put_request
                                     blk_finish_request
                                     blk_end_bidi_request
                                     blk_end_request
                                     scsi_io_completion
                                     scsi_finish_command
                                     scsi_softirq_done
                                     blk_done_softirq
                                     __do_softirq
                                     call_softirq
                                     do_softirq
                                     irq_exit
                                     do_IRQ
                                     ret_from_intr
                                     cpuidle_idle_call
                                     cpu_idle
                                     start_secondary

     5.85%  chromium-browse  [kernel.kallsyms]  [k] blk_peek_request
            |
            --- blk_peek_request
                scsi_request_fn
                __blk_run_queue
                blk_run_queue
                scsi_run_queue
                scsi_next_command
                scsi_io_completion
                scsi_finish_command
                scsi_softirq_done
                blk_done_softirq
                __do_softirq
                call_softirq
                do_softirq
                irq_exit
                do_IRQ
                ret_from_intr
               |          
               |--50.00%-- check_match.8653
               |          
                --50.00%-- unlink_anon_vmas
                          free_pgtables
                          exit_mmap
                          mmput
                          exit_mm
                          do_exit
                          do_group_exit
                          sys_exit_group
                          system_call
...
