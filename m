Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab1FPQIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:08:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47367 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1FPQI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=QdR18T/AxGK18sYJmQqtTsPr4vn2e/EdX8ECqiAbwFeP/XGjqJxdfOkLV5U78sHXWK
         KuwnuwjlNUJxbQrW0zqfCLkfz4yr2syqrnQYzaW3KVvwJr0/kv1/zV+D4WLX9vFywvtY
         32Jub4gHO9iOhLlStnyKsw7XZ0LJg1GB/VHrU=
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Erez Zadok <ezk@fsl.cs.sunysb.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "viro\@ZenIV.linux.org.uk Viro" <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<4540f7aa16724111bd792a1d577261c2@HUBCAS1.cs.stonybrook.edu>
	<954F11FF-339B-48E2-8358-A158DE1E53BC@fsl.cs.sunysb.edu>
	<12728.1308237302@jrobl>
Date: Thu, 16 Jun 2011 18:09:02 +0200
In-Reply-To: <12728.1308237302@jrobl> (J. R. Okajima's message of "Fri, 17 Jun
	2011 00:15:02 +0900")
Message-ID: <87hb7piwrl.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. R. Okajima" <hooanon05@yahoo.co.jp> writes:

>> over the years developing a standalone stackable file system based =
>> approach.  These approaches were rejected largely due to their =
> 	:::
>> location for this functionality.  There is some merit to a VFS based =
>> approach: unioning performs a fair amount of namespace manipulation =
>> (merging directories, eliminating duplications, whiteouts and opaques, =
>> etc.), and the VFS is often best suited for complex namespace =
>> operations.
>
> Exactly.
> I understand everybody likes simpler patch, and I have no objection to
> merge UnionMount into mainline. But this union-type-mount approach has
> some demerit which I have posted before. Those are inherited by
> overlayfs too, and Miklos called it "unPOSIXy behavior". I think the
> most part of the cause of these behaviour came from its design or
> architecture.

Yes, overlayfs shares some of the basic architecture of union-mounts.
The most important such property is that when a file is copied up, it's
like replacing the file with a new one:

   cp /foo/bar /tmp/ttt
   mv -f /tmp/ttt /foo/bar

Which is exactly the thing that some editors do when saving a modified
file, so most applications should handle this behavior fine.  The truth
is a bit more complicated and the effect of the copy-up is more like
this:

   cp /foo/bar /tmp/ttt
   mount --bind /tmp/ttt /foo/bar

> Additionally the number of members may be important too. Overlayfs
> supports only two members currently. When a user wants more layers,
> he has to mount another overlayfs over overlayfs. Since it is
> essentially equivalent to a recursive function call internally, and of
> course the stack size in kernel space is limited, I don't think it is
> good.

Good point about stack space.

Adding multiple read-only layers should be really easy, and could be one
of the first extensions after the merge.

> Also Miklos replied and said modifying the credentials internally does
> no harm to other threads. But I am still afraid it a security hole since
> the credentials is shared among threads. If I had time, I would test it
> by myself.

The credentials of the current task are not modified but replaced by
new, temporary credentials.  This will only have an affect on a single
thread.

Thanks,
Miklos
