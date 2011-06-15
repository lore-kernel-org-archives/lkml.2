Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab1FOLSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 07:18:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50899 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab1FOLSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 07:18:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=qpJNjlWq6CbXrYnurjot64XJ4Y+DaAWYmoOdarbV5pd5qan7fNooJZRE5ZbQGlV3oV
         +OhTdcVLIf6XIZy6ULLDJYVLc3xYsA/Vlj5OnJ2O6/CdYB0AqE9/MTazFaGSSFeto0M9
         t84VTcgd2XQl8d68H1vrfxFDnLQ7HagX410Zw=
From: Miklos Szeredi <miklos@szeredi.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Valerie Aurora <val@vaaconsulting.com>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <20110609125114.8dff08da.akpm@linux-foundation.org>
	<BANLkTi=uWDSw96v0Y4W94NZvgD=j=3r3zg@mail.gmail.com>
	<20110610100143.28037551@lxorguk.ukuu.org.uk>
Date: Wed, 15 Jun 2011 13:19:12 +0200
In-Reply-To: <20110610100143.28037551@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Fri, 10 Jun 2011 10:01:43 +0100")
Message-ID: <8739jbjqa7.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> 1. Al Viro and Christoph Hellwig bring up the same locking problems
>> *every single time* someone proposes a copy-up in-kernel file system,
>> and *every single time* they are dismissed or hand-waved.  
>
> Perhaps you can detail the locking problem in question ?

Pretty bizarre things can happen when the topology of the underlying
layers change after overlayfs acquired refs to underlying dentries.  I
think this is the case Val is talking about.

Example:

# mount -toverlayfs x -oupperdir=/upper,lowerdir=/lower /ovl
# mkdir -p /upper/a/b
# ls /ovl/a/b
# mv /upper/a/b /upper/
# mv /upper/a /upper/b/
# ls  /ovl/a/b
a

Apparently "a" became its own ancestor.

Overlayfs is careful not to assume anything about child/parent
relationships of underlying dentries.

For example "rmdir /ovl/a/b" will do the following:

  1. find the underlying dentry for "a" -> upper-a
  2. lock upper-a
  3. find the underlying dentry for "b" -> upper-b
  4. verify that upper-b is a child of upper-a
  5. remove upper-b

With the above example it will fail on step 4.  Changes to the
underlying filesystems are not supported and result in undefined
behavior.  But it should never result in BUGs or deadlocks.

The overall locking order is:

-> overlayfs locks
  -> upper fs locks
  -> lower fs locks

Within each filesystem the usual locking rules apply.

One more difficulty is copy-up.  This happens without being protected by
i_mutex on overlayfs.  The rules here are: 

 A. directory renames only succeed if both source and destination are
    only on the upper fs (never copied up)
 B. non-directory renames start with copy-up of source if necessary
 C. copy-up takes i_mutex on upper parent

During copy-up no ancestor will be renamed because of A.

The file being copied up may be moved concurrently, however.  If this
happens then copy-up will acquire i_mutex for either the old or the new
upper parent.  In the latter case the file has already been copied up.
In the former case the file may or may not have been copied up.  The
state of the file is checked after having locked the upper parent and
the copy-up skipped if it has already succeeded.

There may be flaws in the above reasoning or the implementation and
reviews are very welcome.

Thanks,
Miklos
