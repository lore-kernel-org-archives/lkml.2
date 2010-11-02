Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0KBSDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 14:03:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab0KBSDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 14:03:47 -0400
Subject: Re: [PATCH v1.2 0/5] IMA: making i_readcount a first class inode
 citizen
From: Eric Paris <eparis@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jmorris@namei.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, Dave Chinner <david@fromorbit.com>
In-Reply-To: <1288717707-5295-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1288717707-5295-1-git-send-email-zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 14:03:29 -0400
Message-ID: <1288721009.3047.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 13:08 -0400, Mimi Zohar wrote:
> Changelog:
> - renamed iget/iput_readcount to i_readcount_inc/dec (Dave Chinner's suggestion)
> - finished cleaning up the locking, so that: (based on Eric's comment.)
> 	- i_lock is not required
> 	- i_mutex is taken when making measurement decisions to prevent
> 	  file metadata(eg. permissions, xattr) changing from under it.
> 	- iint->mutex is taken when accessing/modifying the iint structure.
> - Based on the previous posting discussion, i_readcount is now defined as
> atomic. 
> 
> This patchset separates the incrementing/decrementing of the i_readcount,
> in the VFS layer, from other IMA functionality, by replacing the current
> ima_counts_get() call with i_readcount_inc(). Its unclear whether this
> call to increment i_readcount should be made earlier, like i_writecount.
> 
> The patch ordering is a bit redundant in order to leave removing the ifdef
> around i_readcount until the last patch. The first four patches: redefines 
> i_readcount as atomic, defines i_readcount_inc/dec(), moves the IMA
> functionality in ima_counts_get() to ima_file_check(), and removes the
> IMA imbalance code, simplifying IMA. The last patch removes the ifdef
> around i_readcount, making i_readcount into a "first class inode citizen".
> 
> The generic_setlease code could then take advantage of i_readcount.
>  
> Mimi
> Mimi Zohar (5):
>   IMA: convert i_readcount to atomic
>   IMA: define readcount functions
>   IMA: maintain i_readcount in the VFS layer
>   IMA: remove IMA imbalance checking
>   IMA: making i_readcount a first class inode citizen


Ack on patches 1-4.  Patch 5 I'm not so sure about.  As long as IMA is
the only user I don't think we really want to unconditionally compile
i_readcount in.  I say we either leave it wrapped in CONFIG_IMA until
there is a second user.  Then we either unconditionally compile it in,
or we wrap it in something that either user can select in the Kconfig.

I'll let others voice their opinion.

-Eric

