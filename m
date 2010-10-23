Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab0JWRVK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 13:21:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42013 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0JWRVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 13:21:08 -0400
Date: Sat, 23 Oct 2010 18:21:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/buffer.c: change buffer_busy() to use logical-OR
 expression
Message-ID: <20101023172107.GQ19804@ZenIV.linux.org.uk>
References: <1287853575-14190-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287853575-14190-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 02:06:15AM +0900, Namhyung Kim wrote:
> Convert bitwise-OR operator to logical-OR in favor of short-circuit
> evaluation. The end result would be same.

It'll cost _more_.

Think of it:
	v = atomic_read(...)
	w = bh->b_state
	w &= constant
	v |= w
	return v
vs.
	v = atomic_read()
	branch to l if not equal to 0
	w = bh->b_state
	if w & constant is not 0, branch to l
	v = 0
	return v
l:	v = 1
	return v

That short-circuit won't win anything here.
