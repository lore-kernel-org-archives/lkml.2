Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab0GURmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:42:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44601 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab0GURmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:42:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N/YW4XFd4HmbHs8mk/SybCtKCHfPlyg8VU8AybJainzzUXMfCk1pixrUdP06t2C+X2
         Q9sZewftD1ZM74lD8umVW7/Svs42ynk0YGYA3GfbkhG3u5ZHv3TrjoKFEM1FX/bU+NvR
         kVVu2LaI6XXhk1muhKlqG9tIPH3v8cvuaM/I0=
MIME-Version: 1.0
In-Reply-To: <20100721172721.GD1215@atrey.karlin.mff.cuni.cz>
References: <871vbax86w.fsf@patl.com>
	<20100721172721.GD1215@atrey.karlin.mff.cuni.cz>
Date: Wed, 21 Jul 2010 10:42:51 -0700
Message-ID: <AANLkTikdCRfgDRLHZ7zr-ZALU8g8LwWc5We-CgbcQ8mF@mail.gmail.com>
Subject: Re: [PATCH 1/2] JBD2: Allow feature checks before journal recovery
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 10:27 AM, Jan Kara <jack@suse.cz> wrote:
>> Signed-off-by: Patrick LoPresti <lopresti@gmail.com>
>>
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index bc2ff59..c5a864f 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -1365,6 +1365,8 @@ int jbd2_journal_check_used_features (journal_t *journal, unsigned long compat,
>>
>>       if (!compat && !ro && !incompat)
>>               return 1;
>> +     if (journal_get_superblock(journal))
>> +             return 0;
>>       if (journal->j_format_version == 1)
>>               return 0;
>
> This looks OK in principle. It would be even nicer to avoid all the checks
> journal_get_superblock() when the superblock is actually loaded so that we
> don't do them each time jbd2_journal_check_used_features is called...

How about this?

         if (!compat && !ro && !incompat)
                return 1;
+        if (journal->j_format_version == 0 &&
journal_get_superblock(journal) != 0)
+               return 0;
        if (journal->j_format_version == 1)
                return 0;

journal_init_common() uses kzalloc() to allocate the journal_t, and
journal_get_superblock() fills it in, so I believe this is a valid
test.

 - Pat
