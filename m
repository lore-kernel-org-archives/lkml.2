Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab1AFX1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:27:17 -0500
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:40688
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864Ab1AFX1P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:27:15 -0500
Subject: Re: Using s3virge card in Sun Blade 2000
From: Alex Buell <alex.buell@munted.org.uk>
Reply-To: alex.buell@munted.org.uk
To: David Miller <davem@davemloft.net>
Cc: romieu@fr.zoreil.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110106.142906.226774601.davem@davemloft.net>
References: <20110106204240.GA6361@electric-eye.fr.zoreil.com>
	 <1294347036.24378.13.camel@lithium> <1294352651.24378.17.camel@lithium>
	 <20110106.142906.226774601.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Thu, 06 Jan 2011 23:25:19 +0000
Message-ID: <1294356319.24378.22.camel@lithium>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-Gradwell-MongoId: 4d264fd0.82fc-16db-2
X-Gradwell-Auth-Method: mailbox
X-Gradwell-Auth-Credentials: postmaster@pop3.munted.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 14:29 -0800, David Miller wrote:
> You have to initialize par->state.vgabase in the s3fb driver to the
> VGA area iomem pointer you calculated at boot time.

Thanks for that, I've just got past that, now it's changing modes that
crashes the driver. I can load and unload the driver,  and it
automatically selects 640x480.

How do I track down the offending line of code from the following entry
in the logs:
TPC<s3fb_set_par+0x1a0/0xf78 [s3fb]>

Also, oddly enough, before calling save_vga it clears par->state, which
was why it was crashing. Explicitly setting the par->state.vgabase to
the vga_iobase address solved the problem as below. I also noticed that
having VGA_SAVE_FONTS crashes the driver, so I left it out - a quick
look through the code in vgastate.c indicate it needs rework to make it
work but I've left that for later. 

(in s3fb_open)

 if (par->ref_count == 0) {
                memset(&(par->state), 0, sizeof(struct vgastate));

                /* save_vga/restore_vga needs this to function */
                par->state.vgabase = par->vga_iobase;

                /*par->state.flags = VGA_SAVE_MODE | VGA_SAVE_FONTS | VGA_SAVE_CMAP;*/
                par->state.flags = VGA_SAVE_MODE | VGA_SAVE_CMAP;
                par->state.num_crtc = 0x70;
                par->state.num_seq = 0x20;
                save_vga(&(par->state));

Thanks, seems it's starting to work bit by bit!
-- 
Tactical Nuclear Kittens
