Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0GUR10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:27:26 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40381 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752381Ab0GUR1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:27:22 -0400
Date: Wed, 21 Jul 2010 19:27:21 +0200
From: Jan Kara <jack@suse.cz>
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/2] JBD2: Allow feature checks before journal recovery
Message-ID: <20100721172721.GD1215@atrey.karlin.mff.cuni.cz>
References: <871vbax86w.fsf@patl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871vbax86w.fsf@patl.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Before we start accessing a huge (> 16 TiB) OCFS2 volume, we need to
> confirm that its journal supports 64-bit offsets.  So we need to check
> the journal's feature bits before recovering the journal.
> 
> This is not possible with JBD2 at present, because the journal
> superblock (where the feature bits reside) is not loaded from disk until
> the journal is recovered.
> 
> This patch loads the journal superblock in
> jbd2_journal_check_used_features() if it has not already been loaded,
> allowing us to check the feature bits before journal recovery.
> 
> Signed-off-by: Patrick LoPresti <lopresti@gmail.com>
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index bc2ff59..c5a864f 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1365,6 +1365,8 @@ int jbd2_journal_check_used_features (journal_t *journal, unsigned long compat,
>  
>  	if (!compat && !ro && !incompat)
>  		return 1;
> +	if (journal_get_superblock(journal))
> +		return 0;
>  	if (journal->j_format_version == 1)
>  		return 0;
  This looks OK in principle. It would be even nicer to avoid all the checks
journal_get_superblock() when the superblock is actually loaded so that we
don't do them each time jbd2_journal_check_used_features is called...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
