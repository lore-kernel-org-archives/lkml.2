Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab2HUSDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:03:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38474 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab2HUSDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:03:32 -0400
MIME-Version: 1.0
In-Reply-To: <1345555236.2231.28.camel@iscandar.digidescorp.com>
References: <1345282899-7534-1-git-send-email-linkinjeon@gmail.com>
 <20120818132524.GW23464@ZenIV.linux.org.uk> <87pq6op9zz.fsf@devron.myhome.or.jp>
 <CAKYAXd_VyRg5PYjcYb_JtDeXHeMSRtwwT665hcMcf4WCer7a_Q@mail.gmail.com>
 <20120820205231.GG5779@fieldses.org> <1345555236.2231.28.camel@iscandar.digidescorp.com>
From: Ravishankar <cyberax82@gmail.com>
Date: Tue, 21 Aug 2012 23:32:51 +0530
Message-ID: <CAO_LctSE2fEspAwdhAeP6Ax+m29SOu3Kv8RMzAo44mfbDSCYnw@mail.gmail.com>
Subject: Re: [PATCH 0/4] fat: fix ESTALE errors
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Namjae Jeon <linkinjeon@gmail.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 6:50 PM, Steven J. Magnani
<steve@digidescorp.com> wrote:
> On Mon, 2012-08-20 at 16:52 -0400, J. Bruce Fields wrote:
>
>> Fo somebody that knows more about fat than me--is there really any hope
>> of making it play well with nfs?
>
> I spent a lot of time looking into FAT ESTALE issues and had proposed
> something similar to Namjae (https://lkml.org/lkml/2012/7/3/378). In the
> discussions and experiments that followed, I eventually came to the
> conclusion that the best I could do was make FAT play "better" with NFS
> (https://lkml.org/lkml/2012/7/10/252).
>

We had initially tried both spins of Steve's patches for our test
scenario (ls -lR on the client, while continually doing a drop_caches
on the server) but still got ESTALE errors on the client. Since
Steve's v2 patch set got accepted, we tried to build on top of that.

> If you define "well" as an absence of server-reported ESTALE due purely
> to inode/dentry cache eviction I'm skeptical that this is possible in
> any way that would be accepted into the mainline kernel.

We thought we got it right until the 'orphaned inode' flaw was pointed
out. At the expense of exposing my ignorance,could some one give me a
hint on what what would happen  if there were writes continually to
two files- (i) one unlinked but still referenced by an open file
descriptor and (ii) the other one newly created but assigned the same
inode number(by virtue of this patch-set) on a FAT disk? From what I
tested, the writes to the first (zombie) file did not affect the
integrity of the contents of the second file and were in fact  'rolled
back' when the file descriptor was closed.Apparently, I'm missing
something here.

Thank you.

> Code that addresses ESTALE on the client side (https://lkml.org/lkml/2012/8/8/244)
> seems to be successful, but since not everyone has control of the client
> code there are cases where a server-side solution is desirable.
>
> There's just no unique way to identify FAT inodes that works across all
> the possible scenarios (renames, power cycles, zero-length files,
> deletion of an object and creation of another - potentially of a
> different type - at the same on-disk position, etc.). Also,  clients are
> sensitive to changes in a file handle - any server "reconstitution" of
> an evicted inode must result in a NFS file handle that is identical to
> the "original" reported to the client, or the client will cry ESTALE
> despite the server's best efforts.
>
> ------------------------------------------------------------------------
> Steven J. Magnani               "I claim this network for MARS!
> www.digidescorp.com              Earthling, return my space modulator!"
>
> #include <standard.disclaimer>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
.-. .- ...- ..
