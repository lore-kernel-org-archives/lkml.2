Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab1FPKCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 06:02:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47463 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991Ab1FPKCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 06:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JA9yMjQnxvVpVITdCGTxqVmM73hu1PJApH9cLaLNjJTmxNdMWr1wTx65+gmSTqchBq
         hga4eQX2llk30kBSEUiz09D/aPTXPFPGrw1DTEQz32HzwAWVRzKI5yQhhOhuwCH008EZ
         Uf3XgZbsRpbGmKqOTUj1C1rJ3wobP7fhWM2UY=
MIME-Version: 1.0
In-Reply-To: <20110616094810.GA19965@infradead.org>
References: <BANLkTi=SHENDBHdtFY_7_qtfqJb_+qKJSw@mail.gmail.com>
	<BANLkTinMDz-sqaX0cyWEoLXt70dowxofvg@mail.gmail.com>
	<4DF92C80.3030106@codemonkey.ws>
	<7A30A509-47AA-4E72-ABF3-937005900F9D@suse.de>
	<4DF93010.1040006@codemonkey.ws>
	<4DF935C1.4020000@codemonkey.ws>
	<BANLkTikmUpF_fsZcpiuMzZQZa17U-cPQAw@mail.gmail.com>
	<BANLkTi=mS43KwRG13ROmZX+HmbrPMVgV=g@mail.gmail.com>
	<20110616092429.GA5484@infradead.org>
	<BANLkTinnSW=EEunCu_d51Mapiv=V03ncQw@mail.gmail.com>
	<20110616094810.GA19965@infradead.org>
Date: Thu, 16 Jun 2011 12:57:36 +0300
X-Google-Sender-Auth: E9MD6JeMEpR9nmyXqXk3Y7qvElw
Message-ID: <BANLkTikoMZCFzA6jUw+ddHZ3x2cvO_NzhA@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Alexander Graf <agraf@suse.de>,
        Prasad Joshi <prasadjoshi124@gmail.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 12:48 PM, Christoph Hellwig <hch@infradead.org> wrote:
> You also missed:
>
> " This system call does not flush disk write caches and thus does not
>  provide any data integrity on systems with volatile disk write
>  caches."
>
> so it's not safe if you either have a cache, or are using btrfs, or
> are using a sparse image, or are using an image preallocated using
> fallocate/posix_fallocate.

Uh-oh. Someone needs to apply this patch to sync_file_range():

diff --git a/fs/sync.c b/fs/sync.c
index ba76b96..32078aa 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -277,6 +277,8 @@ SYSCALL_DEFINE(sync_file_range)(int fd, loff_t
offset, loff_t nbytes,
        int fput_needed;
        umode_t i_mode;

+       WARN_ONCE(1, "when this breaks, you get to keep both pieces");
+
        ret = -EINVAL;
        if (flags & ~VALID_FLAGS)
                goto out;


>> What's the right thing to do here? Is fdatasync() sufficient?
>
> Yes.

We'll fix that up. Thanks Christoph!

                         Pekka
