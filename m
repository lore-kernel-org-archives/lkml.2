Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab0DEUAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:00:44 -0400
Received: from imr2.ericy.com ([198.24.6.3]:46214 "EHLO imr2.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab0DEUAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:00:40 -0400
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if
 CONFIG_VGA_CONSOLE is undefined
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: linux-kernel@vger.kernel.org, hpa@zytor.com
CC: penberg@cs.helsinki.fi, mingo@redhat.com, x86@kernel.org
In-Reply-To: <4BBA3021.9090504@zytor.com>
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>
	 <84144f021003310832i3420e4c1g7396b4d1f311f393@mail.gmail.com>
	 <1270491029.1477.453.camel@groeck-laptop>  <4BBA3021.9090504@zytor.com>
Content-Type: text/plain
Organization: Ericsson
Date: Mon, 5 Apr 2010 13:02:05 -0700
Message-ID: <1270497725.1477.488.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-05 at 14:46 -0400, H. Peter Anvin wrote:
> On 04/05/2010 11:10 AM, Guenter Roeck wrote:
> > On Wed, 2010-03-31 at 11:32 -0400, Pekka Enberg wrote:
> >> On Wed, Mar 31, 2010 at 4:41 PM, Guenter Roeck
> >> <guenter.roeck@ericsson.com> wrote:
> >>> Current early_printk code writes into VGA memory space even
> >>> if CONFIG_VGA_CONSOLE is undefined. This can cause problems
> >>> if there is no VGA device in the system, especially if the memory
> >>> is used by another device.
> >>>
> >>> Fix problem by redirecting output to early_serial_console
> >>> if CONFIG_VGA_CONSOLE is undefined.
> >>>
> >>> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> >>
> >> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> >>
> > What will it take to get this patch into the tree ?
> > 
> > If there are coding style issues or some other unresolved concerns,
> > please let me know.
> > 
> 
> You didn't answer my question (c).
> 
> I want to know how you ended up with
> boot_params.screen_info.orig_video_isVGA == 1 on a system with no VGA,
> which seems like it would have resolved this.
> 
> I am *not* inclined to add a compile-time test for what should have been
> handed with a runtime test already.
> 
Sorry, I thought I did answer it.

The problem is that early_printk() can be called prior to the call to
setup_early_printk(). Since early_console is currently pre-initialized
with early_vga_console, output can be written to VGA memory space even
if there is no VGA controller in the system (and even if
boot_params.screen_info.orig_video_isVGA == 0). This happens for all
early_printk() calls executed prior to the call to setup_early_printk().

I don't mind taking out have_vga_console, if that is the issue. That is
just an optimization resulting in the entire VGA code to be optimized
away if CONFIG_VGA_CONSOLE is not defined. The important part of the
patch is to not pre-initialize early_console with early_vga_console if
CONFIG_VGA_CONSOLE is not defined.

An alternative might be to not pre-initialize early_console at all, and
to modify early_printk() to not do anything if early_console is NULL.
However, that would result in output such as "Kernel alive" to not be
displayed at all, which I assumed would be undesirable.

Guenter


