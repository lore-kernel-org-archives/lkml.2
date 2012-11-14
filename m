Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab2KNVgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 16:36:38 -0500
Received: from mx2.netapp.com ([216.240.18.37]:33997 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab2KNVgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 16:36:36 -0500
X-IronPort-AV: E=Sophos;i="4.83,252,1352102400"; 
   d="scan'208";a="710156997"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v3] SUNRPC: set desired file system root before
 connecting local transports
Thread-Topic: [PATCH v3] SUNRPC: set desired file system root before
 connecting local transports
Thread-Index: AQHNplUzozW+CxsorEGJ6nqK7Kz9MZfdSI4AgAAfQQCAAAl4gIAAB2gAgAAA5QCAAAc0gIAB5YyAgAc1IgCAA/RXgIAACd4A
Date: Wed, 14 Nov 2012 21:36:33 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA9092E0A40@SACEXCMBX04-PRD.hq.netapp.com>
References: <20121008105437.18668.99905.stgit@localhost.localdomain>
	 <20121009193506.GA19680@fieldses.org> <5098E31A.5080801@parallels.com>
	 <20121106120642.GA6718@fieldses.org> <20121106124035.GA20522@infradead.org>
	 <20121106130705.GC6718@fieldses.org> <20121106131018.GA12211@infradead.org>
	 <20121106133605.GD6718@fieldses.org> <20121107183355.GA7421@fieldses.org>
	 <50A0B562.2090807@parallels.com> <20121114210112.GA539@fieldses.org>
In-Reply-To: <20121114210112.GA539@fieldses.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.114]
Content-Type: text/plain; charset="utf-8"
Content-ID: <609AF0DC32E47E40A778CD7F5A3E04D3@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAELajwH024789

On Wed, 2012-11-14 at 16:01 -0500, J. Bruce Fields wrote:
> On Mon, Nov 12, 2012 at 12:37:54PM +0400, Stanislav Kinsbursky wrote:
> > 07.11.2012 22:33, J. Bruce Fields Ğ¿Ğ¸ÑˆĞµÑ‚:
> > >On Tue, Nov 06, 2012 at 08:36:05AM -0500, J. Bruce Fields wrote:
> > >>On Tue, Nov 06, 2012 at 08:10:18AM -0500, Christoph Hellwig wrote:
> > >>>On Tue, Nov 06, 2012 at 08:07:06AM -0500, J. Bruce Fields wrote:
> > >>>>So you're worried that a bug in the nfs code could modify the root and
> > >>>>then not restore it?
> > >>>
> > >>>At least the link you pointed to earlier never sets it back.
> > >>
> > >>This? http://thread.gmane.org/gmane.linux.kernel/1259986/focus=47687
> > >>
> > >>	+	get_fs_root(current->fs, &root);
> > >>	+	set_fs_root(current->fs, &transport->root);
> > >>	+
> > >>	 	status = xs_local_finish_connecting(xprt, sock);
> > >>	+
> > >>	+	set_fs_root(current->fs, &root);
> > >>	+	path_put(&root);
> > >>
> > >>>Instead
> > >>>of messing with it I'd rather have the sunrpc code use vfs_path_lookup
> > >>>and not care about current->fs->root at all.
> > >>
> > >>The annoyance is that the lookup happens somewhere lower down in the
> > >>networking code (net/unix/af_unix.c:unix_find_other, I think).  So we'd
> > >>need some new (internal) API.  We'd likely be the only user of that new
> > >>API.
> > >
> > >So, if the only drawback is really just the risk of introducing a bug
> > >that leaves the fs_root changed--the above seems simple enough for that
> > >not to be a great risk, right?
> > >
> > 
> > If we unshare rpciod fs struct (which is exported already), then we
> 
> I'm not sure what you mean by that.  Do workqueues actually have their
> own dedicated set of associated tasks?  I thought all workqueues shared
> a common pool of tasks these days.
> 
> > won't affect other kthreads by root swapping.
> > But would be great to hear Trond's opinion about this approach.
> > 
> > Trond, could you tell us your feeling about all this?
> 
> I think it's often easier to get people to comment on an actual patch,
> and this one would be quite short, so try that....

unshare() would break expectations for other users of workqueue threads
unless you "reshare()" afterwards. Either way that's going to be
seriously ugly.

OK, let's look at this again. Do we ever use AF_LOCAL connections for
anything other than synchronous rpc calls to the local rpcbind daemon in
order to register/unregister new services? If not, then let's just move
the AF_LOCAL connection back into the process context and out of rpciod.

That implies that the process needs to be privileged, but it needs
privileges in order to start RPC daemons anyway.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
