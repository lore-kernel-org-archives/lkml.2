Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199Ab2ATFYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 00:24:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46323 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2ATFYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 00:24:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAKYAXd8poi6Rs7wyvZHre6qx-_i7eq0SBQAJNKNTYTLC5RQKjA@mail.gmail.com>
References: <20120116025331.GA16516@localhost> <1326991820-31393-1-git-send-email-rabin@rab.in>
 <CAKYAXd8poi6Rs7wyvZHre6qx-_i7eq0SBQAJNKNTYTLC5RQKjA@mail.gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Fri, 20 Jan 2012 10:54:11 +0530
X-Google-Sender-Auth: D8H1KkEKjTJSrPmi8_Pr7zNLtUM
Message-ID: <CAH+eYFBHTXVxdepno4xE-AxyYKqtNQHUvCY55z9_otN+25Y8Hg@mail.gmail.com>
Subject: Re: [PATCHv2] backing-dev: fix wakeup timer races with bdi_unregister()
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: fengguang.wu@intel.com, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        chanho0207@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 05:16, Namjae Jeon <linkinjeon@gmail.com> wrote:
>>                bdi_debug_unregister(bdi);
>> -               device_unregister(bdi->dev);
>> +
>> +               spin_lock_bh(&bdi->wb_lock);
>>                bdi->dev = NULL;
>> +               spin_unlock_bh(&bdi->wb_lock);
> Hi.
> Would you explain me why you add spinlock in here ?

wakeup_timer_fn() does the following, where the
trace_writeback_wake_forker_thread() also accesses bdi->dev.
It does this under the wb_lock:

	} else if (bdi->dev) {
		/*
		 * When bdi tasks are inactive for long time, they are killed.
		 * In this case we have to wake-up the forker thread which
		 * should create and run the bdi thread.
		 */
		trace_writeback_wake_forker_thread(bdi);

If we don't have the lock above, the bdi->dev could potentially be
cleared after the check but before the tracepoint is hit, leading to a
NULL pointer dereference.
