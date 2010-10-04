Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0JDNue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:50:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972Ab0JDNuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:50:32 -0400
Date: Mon, 4 Oct 2010 15:50:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-input@vger.kernel.org, Alan Ott <alan@signal11.us>,
        Oliver Neukum <oliver@neukum.name>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hidraw, fix a NULL pointer dereference in
 hidraw_ioctl
In-Reply-To: <1286018724-7484-1-git-send-email-ospite@studenti.unina.it>
Message-ID: <alpine.LNX.2.00.1010041548580.29535@pobox.suse.cz>
References: <1286018724-7484-1-git-send-email-ospite@studenti.unina.it>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Oct 2010, Antonio Ospite wrote:

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> IP: [<ffffffffa02c66b4>] hidraw_ioctl+0xfc/0x32c [hid]
> [...]
> 
> This is reproducible by disconnecting the device while userspace does ioctl in
> a loop and doesn't check return values in order to exit the loop, like in the
> following test program:
> 
> int main(int argc, char *argv[])
> {
> 	int fd = -1;
> 	unsigned char name[256];
> 	int ret;
> 
> 	if (argc != 2) {
> 		fprintf(stderr, "usage: %s </dev/hidrawX>\n",
> 				argv[0]);
> 		exit(1);
> 	}
> 
> 	fd = open(argv[1], O_RDWR);
> 	if (fd < 0) {
> 		perror("hidraw open");
> 		exit(1);
> 	}
> 
> 	while (1) {
> 		ret = ioctl(fd, HIDIOCGRAWNAME(256), name);
> 		printf("ret: %d name: %s\n", ret, name);
> 	}
> 
> 	close(fd);
> 	exit(0);
> }

Thanks for cathing this.

> 
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> ---
> Should this be applied to older stable kernels too?

Yes, I will be adding (or feel free to do so yourself with another respin) 
"Cc: stable@kernel.org" line.

> there is a similar problem when _writing_ to the device, but Alan's
> changes in that area are shuffling the code a bit, should I send a patch
> [to hidraw_send_report()] on top of Alan's work for that, or a fix for
> current mainline [in hidraw_write()] on which Alan should rebase his
> work would be better?

Please send me the fix for current mainline for now, i.e. respin with the 
write path covered as well. We are struggling to get feedback on Alan's 
patches from Bluetooth maintainer, so we'd rather have this race fixed in 
any case.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
