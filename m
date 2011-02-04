Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab1BDLlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 06:41:19 -0500
Received: from nbd.name ([46.4.11.11]:52859 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab1BDLlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 06:41:15 -0500
Message-ID: <4D4BE5D7.8090202@openwrt.org>
Date: Fri, 04 Feb 2011 12:41:11 +0100
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Wireless regression (was 2.6.38-rc3: FUSE (sshfs) hangs under
 load)
References: <20110201175452.GB518@core.coreip.homeip.net> <E1PkbGG-0005Rf-QL@pomaz-ex.szeredi.hu> <20110202165236.GA3178@core.coreip.homeip.net> <20110203065541.GB5592@core.coreip.homeip.net> <E1Pkx7s-00073l-5B@pomaz-ex.szeredi.hu> <20110203194115.GA14159@core.coreip.homeip.net> <20110204064952.GA12914@core.coreip.homeip.net>
In-Reply-To: <20110204064952.GA12914@core.coreip.homeip.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-04 7:49 AM, Dmitry Torokhov wrote:
> On Thu, Feb 03, 2011 at 11:41:15AM -0800, Dmitry Torokhov wrote:
>> On Thu, Feb 03, 2011 at 12:13:24PM +0100, Miklos Szeredi wrote:
>> > On Wed, 2 Feb 2011, Dmitry Torokhov wrote:
>> > > On Wed, Feb 02, 2011 at 08:52:36AM -0800, Dmitry Torokhov wrote:
>> > > > On Wed, Feb 02, 2011 at 12:52:36PM +0100, Miklos Szeredi wrote:
>> > > > > On Tue, 1 Feb 2011, Dmitry Torokhov wrote:
>> > > > > > Hi,
>> > > > > > 
>> > > > > > After installing 2.6.38-rc3 (plus a few input patches) sshfs started to
>> > > > > > misbehave on me under load. It starts off fine but when I try to compile
>> > > > > > a few modules against kernel sources residing on the other box the
>> > > > > > processes go into 'D' state and just sit there doing nothing.
>> > > > > 
>> > > > > Can you please post a stack trace from SysRq-T?
>> > > > > 
>> > > > 
> ...
>> > > 
>> > > OK, so here are the stack traces you requested. First one is snapshot of
>> > > when compile got stuck, the 2nd one is when I interrupted make which
>> > > caused gcc to go to 'D' state.
>> > 
>> > There doesn't appear anything abnormal there.
>> > 
>> > It's going into D state after it has received an interrupt and sent it
>> > along to the userspace filesystem.  Then it will go into
>> > uninterruptible sleep until the answer is received.
>> > 
>> > So the hang is because the answer to an open request is not being
>> > received.  I can't tell where it got stuck, apparently not anywhere on
>> > the local machine.
>> > 
>> > Can you please get a log from sshfs with "-odebug,sshfs_debug" and
>> > redirect stderr to a file?  That might tell a bit more about the
>> > situation.  Or it might not...
>> 
>> Hmm, it might be just the network itself, last night mutt in ssh session
>> froze on me as well. I guess I'll just have to finish my bisect
>> exercise.
>> 
> 
> I finished bisecting and it turned out that the problematic commit
> happened to be in wireless (I have iwl3945):
> 
> commit 4cd06a344db752f513437138953af191cbe9a691
> Author: Felix Fietkau <nbd@openwrt.org>
> Date:   Sat Dec 18 19:30:49 2010 +0100
> 
>     mac80211: skip unnecessary pskb_expand_head calls
> 
>     If the skb is not cloned and we don't need any extra headroom, there
>     is no point in reallocating the skb head.
> 
>     Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> With this commit reverted from 2.6.38-rc3 I can not reproduce sshfs
> getting stuck here.
I really don't see how this commit could be causing these issues, and
I'm not aware of any similar issues affecting other drivers.

- Felix
