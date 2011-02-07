Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab1BGIGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 03:06:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43791 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1BGIGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 03:06:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jORPvuyI0KGaNyTXP1zagxBsDoYlyYzZ7k18gU5Syro0TVsMubaST2oofkSGUi5G5f
         8mYqwMfsDLVJGCC6FYvN2xoZWd7YhOXpKhnnQx7sK7+nohFFxJOG6loVjH1dnY6z9IBl
         S3TZUZqjxdwdlf3wPThvysArK59tXS7xfUUS8=
Date: Mon, 7 Feb 2011 00:06:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Wireless regression (was 2.6.38-rc3: FUSE (sshfs) hangs under
 load)
Message-ID: <20110207080634.GA11580@core.coreip.homeip.net>
References: <20110201175452.GB518@core.coreip.homeip.net>
 <E1PkbGG-0005Rf-QL@pomaz-ex.szeredi.hu>
 <20110202165236.GA3178@core.coreip.homeip.net>
 <20110203065541.GB5592@core.coreip.homeip.net>
 <E1Pkx7s-00073l-5B@pomaz-ex.szeredi.hu>
 <20110203194115.GA14159@core.coreip.homeip.net>
 <20110204064952.GA12914@core.coreip.homeip.net>
 <4D4BE5D7.8090202@openwrt.org>
 <4D4BEB99.4060202@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4BEB99.4060202@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 01:05:45PM +0100, Felix Fietkau wrote:
> On 2011-02-04 12:41 PM, Felix Fietkau wrote:
> > On 2011-02-04 7:49 AM, Dmitry Torokhov wrote:
> >> On Thu, Feb 03, 2011 at 11:41:15AM -0800, Dmitry Torokhov wrote:
> >>> On Thu, Feb 03, 2011 at 12:13:24PM +0100, Miklos Szeredi wrote:
> >>> > On Wed, 2 Feb 2011, Dmitry Torokhov wrote:
> >>> > > On Wed, Feb 02, 2011 at 08:52:36AM -0800, Dmitry Torokhov wrote:
> >>> > > > On Wed, Feb 02, 2011 at 12:52:36PM +0100, Miklos Szeredi wrote:
> >>> > > > > On Tue, 1 Feb 2011, Dmitry Torokhov wrote:
> >>> > > > > > Hi,
> >>> > > > > > 
> >>> > > > > > After installing 2.6.38-rc3 (plus a few input patches) sshfs started to
> >>> > > > > > misbehave on me under load. It starts off fine but when I try to compile
> >>> > > > > > a few modules against kernel sources residing on the other box the
> >>> > > > > > processes go into 'D' state and just sit there doing nothing.
> >>> > > > > 
> >>> > > > > Can you please post a stack trace from SysRq-T?
> >>> > > > > 
> >>> > > > 
> >> ...
> >>> > > 
> >>> > > OK, so here are the stack traces you requested. First one is snapshot of
> >>> > > when compile got stuck, the 2nd one is when I interrupted make which
> >>> > > caused gcc to go to 'D' state.
> >>> > 
> >>> > There doesn't appear anything abnormal there.
> >>> > 
> >>> > It's going into D state after it has received an interrupt and sent it
> >>> > along to the userspace filesystem.  Then it will go into
> >>> > uninterruptible sleep until the answer is received.
> >>> > 
> >>> > So the hang is because the answer to an open request is not being
> >>> > received.  I can't tell where it got stuck, apparently not anywhere on
> >>> > the local machine.
> >>> > 
> >>> > Can you please get a log from sshfs with "-odebug,sshfs_debug" and
> >>> > redirect stderr to a file?  That might tell a bit more about the
> >>> > situation.  Or it might not...
> >>> 
> >>> Hmm, it might be just the network itself, last night mutt in ssh session
> >>> froze on me as well. I guess I'll just have to finish my bisect
> >>> exercise.
> >>> 
> >> 
> >> I finished bisecting and it turned out that the problematic commit
> >> happened to be in wireless (I have iwl3945):
> >> 
> >> commit 4cd06a344db752f513437138953af191cbe9a691
> >> Author: Felix Fietkau <nbd@openwrt.org>
> >> Date:   Sat Dec 18 19:30:49 2010 +0100
> >> 
> >>     mac80211: skip unnecessary pskb_expand_head calls
> >> 
> >>     If the skb is not cloned and we don't need any extra headroom, there
> >>     is no point in reallocating the skb head.
> >> 
> >>     Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> >>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> >> 
> >> With this commit reverted from 2.6.38-rc3 I can not reproduce sshfs
> >> getting stuck here.
> > I really don't see how this commit could be causing these issues, and
> > I'm not aware of any similar issues affecting other drivers.
> Could you please try this patch to see if it fixes the issue as well?
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index ffc6749..3168eae 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1547,7 +1547,7 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
>  		skb_orphan(skb);
>  	}
>  
> -	if (skb_header_cloned(skb))
> +	if (skb_cloned(skb))
>  		I802_DEBUG_INC(local->tx_expand_skb_head_cloned);
>  	else if (head_need || tail_need)
>  		I802_DEBUG_INC(local->tx_expand_skb_head);

Yes, it does, thank you for fixing it.

-- 
Dmitry
