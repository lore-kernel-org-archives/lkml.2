Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0INTRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:17:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370Ab0INTRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:17:39 -0400
Date: Tue, 14 Sep 2010 12:17:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Timur Tabi <timur@freescale.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, kumar.gala@freescale.com,
        amit.shah@redhat.com
Subject: Re: [PATCH] hvc_console: fix dropping of characters when output
 byte channel is full
Message-Id: <20100914121721.c8671ed8.akpm@linux-foundation.org>
In-Reply-To: <1282329921-24394-1-git-send-email-timur@freescale.com>
References: <1282329921-24394-1-git-send-email-timur@freescale.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 13:45:21 -0500
Timur Tabi <timur@freescale.com> wrote:

> hvc_console_print() calls the HVC client driver's put_chars() callback
> to write some characters to the console.  If the callback returns 0, that
> indicates that no characters were written (perhaps the output buffer is
> full), but hvc_console_print() treats that as an error and discards the
> rest of the buffer.
> 
> So change hvc_console_print() to just loop and call put_chars() again if it
> returns a 0 return code.

Seems rather dangerous.  The upper layer will sit there chewing 100%
CPU for as long as the lower layer is congested.

> This change makes hvc_console_print() behave more like hvc_push(), which
> does check for a 0 return code and re-schedules itself.

Yes, hvc_push() reschedules.  It doesn't sit in a tight loop burning
electrons!

Can we do something safer&smarter here?
