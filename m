Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030512Ab2CNUKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:10:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49769 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759621Ab2CNUKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:10:50 -0400
Date: Wed, 14 Mar 2012 20:10:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
Subject: Re: [PATCH] vfs namespace: Don't assume mount namespace has valid
 root
Message-ID: <20120314201048.GI23916@ZenIV.linux.org.uk>
References: <1331758710-16400-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331758710-16400-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 04:58:30PM -0400, Sasha Levin wrote:
> This patch fixes the assumption that a mnt namespace will always have a valid
> root object.

It's not an assumption, it's an invariant that should hold unless you have
run into a bug somewhere.

Instances of struct mnt_namespace should *all* come from alloc_mnt_ns().
There are only two callers - dup_mnt_namespace() and create_mnt_ns().
The latter will assign non-NULL vfsmount to ->root or die NULL pointer
dereference in
                mnt->mnt_ns = new_ns;
The former will either assign non-NULL to ->root or kfree() mnt_namespace
before anyone can see it.

And nothing should modify ->root after that assignment for as long as
the instance of struct mnt_namespace is allocated.

Mind explaining how have you managed to get mnt_namespace with NULL ->root
passed to dup_mnt_ns()?
