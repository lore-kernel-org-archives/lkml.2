Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab2BTQb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:31:57 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54947 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2BTQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:31:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of shmulik.ladkani@gmail.com designates 10.180.78.233 as permitted sender) smtp.mail=shmulik.ladkani@gmail.com; dkim=pass header.i=shmulik.ladkani@gmail.com
Date: Mon, 20 Feb 2012 18:31:45 +0200
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <rw@linutronix.de>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Subject: Re: [RFC][PATCH 6/7] MTD: UBI: Implement checkpointing support
Message-ID: <20120220183145.6ddbbec0@pixies.home.jungo.com>
In-Reply-To: <1329250006-22944-7-git-send-email-rw@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
	<1329250006-22944-7-git-send-email-rw@linutronix.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012 21:06:45 +0100 Richard Weinberger <rw@linutronix.de> wrote:
> Implements UBI checkpointing support.
> It reduces the attaching time from O(N) to O(1).
> Checkpoints are written on demand and upon changes of the volume layout.
> If the recovery from a checkpoint fails we fall back to scanning mode.

Partially reviewed the feature. Great work.
There's some tiny styling/coding issues, will send references if you'd
like.

I'll comment on the feature itself later on.

Meanwhile, there's a potential memleak/crash you might wanna fix.

> +/* Reads the checkpoint data from it's PEBs */
> +struct ubi_scan_info *ubi_read_checkpoint(struct ubi_device *ubi, int cb_sb_pnum)
> +{
> +	struct ubi_cp_sb *cpsb;
> +	struct ubi_vid_hdr *vh;
> +	int ret, i, nblocks;
> +	char *cp_raw;
> +	size_t cp_size;
> +	__be32 data_crc;
> +	unsigned long long sqnum = 0;
> +	struct ubi_scan_info *si = NULL;
> +
> +	cpsb = kmalloc(sizeof(*cpsb), GFP_KERNEL);
> +	if (!cpsb) {
> +		si = ERR_PTR(-ENOMEM);
> +		goto out;
> +	}
> +
> +	ret = ubi_io_read(ubi, cpsb, cb_sb_pnum, ubi->leb_start, sizeof(*cpsb));
> +	if (ret) {
> +		ubi_err("Unable to read checkpoint super block");
> +		si = ERR_PTR(ret);
> +		goto out;

s/goto out/goto free_sb/
(otherwise 'cpsb' not freed)

> +	/* cp_raw will contain the whole checkpoint */
> +	cp_raw = vzalloc(cp_size);

  ...

> +
> +	cpsb = (struct ubi_cp_sb *)cp_raw;

'cpsb' is overwritten, but formerly kmalloced (at the beginning of
ubi_read_checkpoint).
Should free 'cpsb' prior assignment, or alternatively use different
variable then 'cpsb'.

  ...

> +
> +free_vhdr:
> +	ubi_free_vid_hdr(ubi, vh);
> +free_raw:
> +	vfree(cp_raw);
> +free_sb:
> +	kfree(cpsb);

Freeing 'cp_raw' and 'cpsb', but in the normal flow, they point to the
same thing.

Regards,
Shmulik
