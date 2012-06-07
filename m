Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494Ab2FGXfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:35:20 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64014 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757386Ab2FGXfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:35:18 -0400
MIME-Version: 1.0
In-Reply-To: <1339111642-869-1-git-send-email-dhsharp@google.com>
References: <1339111642-869-1-git-send-email-dhsharp@google.com>
From: David Sharp <dhsharp@google.com>
Date: Thu, 7 Jun 2012 16:34:55 -0700
Message-ID: <CAJL_eku9byV+Uk-5boR52HLEO0D-++2h_y=PeaaQG_PrCuALhQ@mail.gmail.com>
Subject: Re: [PATCH] ring-buffer: fix uninitialized read_stamp
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: vnagarnaik@google.com, David Sharp <dhsharp@google.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 4:27 PM, David Sharp <dhsharp@google.com> wrote:
> This fixes a scenario in which trace_pipe_raw will return events with invalid
> timestamps when events are copied out one at a time (instead of swapping out
> the reader page with a spare page). In this scenario, ring_buffer_read_page()
> uses cpu_buffer->read_stamp to keep track of the time of the earliest event.
> However, cpu_buffer->read_stamp was not always updated. The only function that
> sets read_stamp to a new valid value is rb_reset_reader_page(), which is called
> only by rb_get_reader_page(). rb_reset_reader_page() was not called when there
> is data immediately available on the page to read (read < rb_page_size()). This
> is the bug.
>
> Setting the read_stamp on the first read from a page fixes the bug.
>
> Tested: On certain lightly-loaded machines, repetitive reads from
> trace_pipe_raw without using splice() would sometimes result in invalid
> timestamps. Poisoning read_stamp in rb_init_page() with a negative value makes
> the problem more visible. After this fix, the invalid timstamps disappear.

err, that's poisoning the bpage->time_stamp, not read_stamp.

>
> Google-Bug-Id: 6410455
> Signed-off-by: David Sharp <dhsharp@google.com>
