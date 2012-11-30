Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab2K3N6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:58:22 -0500
Received: from mx2.netapp.com ([216.240.18.37]:55981 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302Ab2K3N6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:58:20 -0500
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="714602219"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Patrick McLean <patrick@cim.mcgill.ca>,
        Patrick McLean <patrickm@gaikai.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: Regression with initramfs and nfsroot (appears to be in the
 dcache)
Thread-Topic: Regression with initramfs and nfsroot (appears to be in the
 dcache)
Thread-Index: AQHNzmYm8ysxO8fgWkOYqEWf8h7YupgB25gAgAAJQACAAAQhgIAACPaAgAAOBwCAAAotgIAABD4AgAAGOoCAAArwAIAABOkAgAAB5ACAAMh4gA==
Date: Fri, 30 Nov 2012 13:58:18 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA90B32EECB@SACEXCMBX04-PRD.hq.netapp.com>
References: <20121129213316.GU4939@ZenIV.linux.org.uk>
	 <CAE2NFgWCnmgSCsw7MzRkqBLTHgRDG-FvKKcbTHN6UqePK6Ef+Q@mail.gmail.com>
	 <20121129222109.GW4939@ZenIV.linux.org.uk> <50B7E759.9070007@gaikai.com>
	 <20121129234326.GX4939@ZenIV.linux.org.uk> <50B7FBA7.2030300@gaikai.com>
	 <20121130003502.GY4939@ZenIV.linux.org.uk> <50B8046F.7030308@cim.mcgill.ca>
	 <20121130013628.GZ4939@ZenIV.linux.org.uk> <50B811BA.6070503@cim.mcgill.ca>
	 <20121130020047.GA4939@ZenIV.linux.org.uk>
In-Reply-To: <20121130020047.GA4939@ZenIV.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0EF724BBA539D046BDA04320D92079F3@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAUDwQcw021437

On Fri, 2012-11-30 at 02:00 +0000, Al Viro wrote:
> On Thu, Nov 29, 2012 at 05:54:02PM -0800, Patrick McLean wrote:
> > > 	Very interesting.  Do you have anything mounted on the corresponding
> > > directories on server?  The picture looks like you are getting empty
> > > fhandles in readdir+ respons for exactly the same directories that happen
> > > to be mountpoints on client.  In any case, we shouldn't do that blind
> > > d_drop() - empty fhandles can happen.  The only remaining question is
> > > why do they happen on that set of entries.  From my reading of
> > > encode_entryplus_baggage() it looks like we have compose_entry_fh()
> > > failing for those entries and those entries alone.  One possible cause
> > > would be d_mountpoint(dchild) being true on server.  If it is true, we
> > > can declare the case closed; if not, I really wonder what's going on.
> > 
> > Those directories do have the server's own copies of the said directories bind mounted at the moment in a separate mount namespace.
> > 
> > Unmounting those directories on the server does appear to stop the WARN_ON from triggering.
> 
> OK, that settles it.  WARN_ON() and printks in the area can be dropped;
> the right fix is below.  However, there's a similar place in cifs that
> also needs to be dealt with and I really, really wonder why the hell do
> we do d_drop() in nfs_revalidate_lookup().  It's not relevant in this
> bug, but I would like to understand what's wrong with simply returning
> 0 from ->d_revalidate() and letting the caller (in fs/namei.c) take care
> of unhashing, etc. itself.  Would make have_submounts() in there pointless
> as well - we could just return 0 and let d_invalidate() take care of the
> checks...  Trond?

The reason for the choice of d_drop over d_invalidate() is the d_count
checks. It really doesn't matter whether or not the client thinks it has
users for a directory if the server is telling you that it is ESTALE. So
we force a d_drop to prevent further lookups from finding it.

IOW: It is there in order to fix the case where the user does
'rmdir("foo"); mkdir("foo")' on the server.


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
