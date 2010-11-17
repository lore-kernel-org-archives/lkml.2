Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934630Ab0KQI1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:27:51 -0500
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:4109 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934603Ab0KQI1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:27:49 -0500
From: Bruno Randolf <br1@einfach.org>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
Date: Wed, 17 Nov 2010 17:28:06 +0900
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: linville@tuxdriver.com, randy.dunlap@oracle.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6> <20101112030035.28522.75318.stgit@localhost6.localdomain6> <20101116093743.GA21872@jm.kir.nu>
In-Reply-To: <20101116093743.GA21872@jm.kir.nu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011171728.06801.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue November 16 2010 18:37:43 Jouni Malinen wrote:
> On Fri, Nov 12, 2010 at 12:00:35PM +0900, Bruno Randolf wrote:
> > Extend nl80211 to report an exponential weighted moving average (EWMA) of
> > the signal value. Since the signal value usually fluctuates between
> > different packets, an average can be more useful than the value of the
> > last packet.
> > 
> > This uses the recently added generic EWMA library function.
> 
> Isn't that generic EWMA library function making this much more CPU
> intensive than necessary? I would assume the compiler is not able to
> optimize the unsigned long division in ewma_add() when the weight value
> is "hidden" in this way through ewma_init() call. While generic library
> functions can be nice, it could be useful to have an option for using an
> inline version of ewma_add that takes in avg->weight as one of the
> arguments to allow cases like weight=8 here to be implemented using
> shift right instead of unsigned long division especially when done on
> hot path..
> 
> > @@ -1158,6 +1158,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data
> > *rx)
> > 
> >  	sta->last_signal = status->signal;
> > 
> > +	ewma_add(&sta->avg_signal, -status->signal);
> 
> This one here would be done for every frame received and by using a
> function call that ends up doing a potentially expensive division.
> 
> > @@ -241,6 +241,8 @@ struct sta_info *sta_info_alloc(struct
> > ieee80211_sub_if_data *sdata, +	ewma_init(&sta->avg_signal, 1000, 8);
> 
> The divisor (weight) is set to 8 here which should allow for quite a bit
> more efficient ewma_add implementation if it were to be done in a way
> that makes it easier for the compiler to see what value is being used
> (e.g., passing this 8 to ewma_add_inline()) to allow shift right to be
> used..
> 
> 
> Or am I missing something here and we have a compiler that is actually
> able to take care of this kind of optimizations by itself in the current
> ewma library design? Or is the unsigned long division with the expected
> weight values going to be fast enough to not justify caring about it
> even on any of the embedded boards anyway?

I understand that this could be more efficient, but if it matters or not - 
honestly, I don't know. Can a more knowledgeable person than me comment on 
this?

bruno
