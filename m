Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab2HUNUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:20:53 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:50537 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab2HUNUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:20:51 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=Aw/7o5BhxWcTKbZO7U9UJT0R57imEFQx9WcDbHO7ELcZzyccXQqDYS8ayA/u
	AlSYowBySCkzytbpez3LIaosX6PH4vMLnFX55CjvhPTzF5GhqbghaPbGG
	ODQFDf++SnnU/yJEsfT38aW3NB/ZFFDGsSj6aEyqPBjKlHLSllJ3RU=;
X-Spam-Processed: mail.digidescorp.com, Tue, 21 Aug 2012 08:20:38 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1580a9bdb4=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1345555236.2231.28.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH 0/4] fat: fix ESTALE errors
From: "Steven J. Magnani" <steve@digidescorp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Date: Tue, 21 Aug 2012 08:20:36 -0500
In-Reply-To: <20120820205231.GG5779@fieldses.org>
References: <1345282899-7534-1-git-send-email-linkinjeon@gmail.com>
	 <20120818132524.GW23464@ZenIV.linux.org.uk>
	 <87pq6op9zz.fsf@devron.myhome.or.jp>
	 <CAKYAXd_VyRg5PYjcYb_JtDeXHeMSRtwwT665hcMcf4WCer7a_Q@mail.gmail.com>
	 <20120820205231.GG5779@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 16:52 -0400, J. Bruce Fields wrote:

> Fo somebody that knows more about fat than me--is there really any hope
> of making it play well with nfs?

I spent a lot of time looking into FAT ESTALE issues and had proposed
something similar to Namjae (https://lkml.org/lkml/2012/7/3/378). In the
discussions and experiments that followed, I eventually came to the
conclusion that the best I could do was make FAT play "better" with NFS
(https://lkml.org/lkml/2012/7/10/252).

If you define "well" as an absence of server-reported ESTALE due purely
to inode/dentry cache eviction I'm skeptical that this is possible in
any way that would be accepted into the mainline kernel. Code that
addresses ESTALE on the client side (https://lkml.org/lkml/2012/8/8/244)
seems to be successful, but since not everyone has control of the client
code there are cases where a server-side solution is desirable. 

There's just no unique way to identify FAT inodes that works across all
the possible scenarios (renames, power cycles, zero-length files,
deletion of an object and creation of another - potentially of a
different type - at the same on-disk position, etc.). Also,  clients are
sensitive to changes in a file handle - any server "reconstitution" of
an evicted inode must result in a NFS file handle that is identical to
the "original" reported to the client, or the client will cry ESTALE
despite the server's best efforts.

------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>


