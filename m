Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab0FLBJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 21:09:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40568 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab0FLBJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 21:09:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UKjFhwSEvzA//IoxveQTJVI5QCMK81t7fJn+7VePKZqomuCsoirKwf4G9iApyB1CoA
         dJvKpsAJZuZRNpRml3ZqumSYM4NDp1OpDtiFBApXAfFt3svZ4ovt9bgLfyayTyByaruS
         D0h3/2xGvZZoyWQIDvD+EaozCLsheRZx3G0lQ=
Subject: Re: [PATCH 2/2] AFFS: wait for sb synchronization when needed
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20100611163151.GE24707@infradead.org>
References: <1276268720-7398-1-git-send-email-dedekind1@gmail.com>
	 <1276268720-7398-3-git-send-email-dedekind1@gmail.com>
	 <20100611163151.GE24707@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Jun 2010 04:09:45 +0300
Message-Id: <1276304985.17909.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 12:31 -0400, Christoph Hellwig wrote:
> On Fri, Jun 11, 2010 at 06:05:20PM +0300, Artem Bityutskiy wrote:
> > From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > 
> > AFFS does not ever wait for superblock synchronization in
> > ->put_super(), ->write_super, and ->sync_fs().
> > 
> > However, it should wait for synchronization in ->put_super() because
> > it is about to be unmounted, in ->write_super() because this is
> > periodic SB synchronization performed from a separate kernel thread,
> > and in ->sync_fs() it should respect the 'wait' flag. This patch fixes
> > the situation.
> > 
> > Also, in ->put_super(), do not write the SB if it is not dirty.
> 
> ->sync_fs should also wait for the superblock I/O to be completed.

Err, depending on the 'wait' flag? I did:

@@ -74,7 +76,7 @@ static int
 affs_sync_fs(struct super_block *sb, int wait)
 {
        lock_super(sb);
-       affs_commit_super(sb, 2);
+       affs_commit_super(sb, wait, 2);
        sb->s_dirt = 0;
        unlock_super(sb);
        return 0;

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

