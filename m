Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab2JFWVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 18:21:22 -0400
Received: from twin.jikos.cz ([89.185.236.188]:37819 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab2JFWVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 18:21:21 -0400
Date: Sun, 7 Oct 2012 00:21:05 +0200
From: David Sterba <dave@jikos.cz>
To: ????????? <jaegeuk.kim@samsung.com>
Cc: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 02/16] f2fs: add on-disk layout
Message-ID: <20121006222104.GA4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: ????????? <jaegeuk.kim@samsung.com>,
	viro@zeniv.linux.org.uk, 'Theodore Ts'o' <tytso@mit.edu>,
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
	chur.lee@samsung.com, cm224.lee@samsung.com,
	jooyoung.hwang@samsung.com
References: <000901cda2f0$7d773eb0$7865bc10$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000901cda2f0$7d773eb0$7865bc10$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 08:56:44PM +0900, ????????? wrote:
> +struct node_footer {
> +	__le32 nid;		/* node id */
> +	__le32 ino;		/* inode nunmber */
> +	__le32 cold:1;		/* cold mark */
> +	__le32 fsync:1;		/* fsync mark */
> +	__le32 dentry:1;	/* dentry mark */
> +	__le32 offset:29;	/* offset in inode's node space */

A bitfield for a on-disk structure? This will have endianity issues,
(but I don't know if you intend to support big-endian). It's not enough
to use cpu_to_le* as in

fill_node_footer(...) {

	rn->footer.offset = cpu_to_le32(ofs);

}

because the bitfield inside the structure will be already defined
reversed. The cpu_to_le macro will only convert value of 'ofs' but will
place it to different bits than it would on a little-endian arch.

There are macros to define bitfields in an endian-neutral way (or do it
by #ifdefs though it also involves duplicating the item names), or you
can alternatively use two structs fr disk-only and memory-only access,
the disk one stores __le32 with value combined of all and the in-memory
gets set up properly and will look like your current version of the
structure.

(More about not using bitfields http://yarchive.net/comp/linux/bitfields.html)

> +	__le64 cp_ver;		/* checkpoint version */
> +	__le32 next_blkaddr;	/* next node page block address */
> +} __packed;
> +


david
