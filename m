Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab1DMC6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 22:58:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37089 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab1DMC6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 22:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ARS+JsxePjWnRzyKG40skmEzyfz7+FoqLpfWzPv7VXPXrvk722l9g/TMyXOdhxN36v
         UZydLqs1Z5vqaOjEZ/bLuLo8zKhCjb5zyCd0WE9wD+1ebDG2AOlrM24j9PixZOMrJ7jL
         XRlQu+8U0+sfLR5FWVFPv9nw8e/juVkaKDNRY=
MIME-Version: 1.0
In-Reply-To: <BANLkTinpQdbyTRY0m+UL7EKF3jAOv=aU1A@mail.gmail.com>
References: <BANLkTinpQdbyTRY0m+UL7EKF3jAOv=aU1A@mail.gmail.com>
Date: Wed, 13 Apr 2011 10:58:47 +0800
Message-ID: <BANLkTi=jEHOVO9v5aaREzCHC5rGBOFcotA@mail.gmail.com>
Subject: Re: Kprobe
From: Lin Ming <minggr@gmail.com>
To: Artur Baruchi <mail.baruchi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 10, 2011 at 10:28 PM, Artur Baruchi <mail.baruchi@gmail.com> wrote:
> Hi Guys.
>
> Im using kprobe to probe a kernel function (find_get_page) and I would
> like to know more details, like which function is calling it, but I
> couldnt figure out a way to do that. Is it possible to use kprobe or
> other kind of probe to detect which function is calling find_get_page
> ?

Do you know the cool "perf" tool.
Its sub command "perf probe" is exactly what you want.

# cd linux-2.6/tools/perf
# make
# ./perf probe -k ~/vmlinux -s ~/linux-2.6/  find_get_page
# ./perf record -e probe:find_get_page -f -g -a
# ./perf report

# Events: 81K
#
# Overhead  Command      Shared Object         Symbol
# ........  .......  .................  .............
#
   100.00%     perf  [kernel.kallsyms]  [k] find_get_page
               |
               --- find_get_page
                  |
                  |--94.84%-- grab_cache_page_write_begin
                  |          ext3_write_begin
                  |          generic_file_buffered_write
                  |          __generic_file_aio_write
                  |          generic_file_aio_write
                  |          do_sync_write
                  |          vfs_write
                  |          sys_write
                  |          system_call_fastpath
                  |          __libc_write
                  |          |
                  |          |--68.98%-- mmap_read_all
                  |          |          __cmd_record
                  |          |          cmd_record
                  |          |          run_builtin
                  |          |          handle_internal_command
                  |          |          run_argv
                  |          |          main
                  |          |          __libc_start_main
                  |          |
                  |          |--29.30%-- mmap_read
                  |          |          mmap_read_all
                  |          |          __cmd_record
                  |          |          cmd_record
                  |          |          run_builtin
                  |          |          handle_internal_command
                  |          |          run_argv
                  |          |          main
                  |          |          __libc_start_main
                  |          |
                  |           --1.72%-- process_synthesized_event
                  |                     |
                  |                     |--87.99%--
perf_event__synthesize_mmap_events
                  |                     |          __event__synthesize_thread
                  |                     |
perf_event__synthesize_threads
                  |                     |          __cmd_record
                  |                     |          cmd_record
                  |                     |          run_builtin
                  |                     |          handle_internal_command
                  |                     |          run_argv
                  |                     |          main
                  |                     |          __libc_start_main

Have a try and you'll like it!

Lin Ming

>
> Thanks in advance.
>
> Att.
> Artur Baruchi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
