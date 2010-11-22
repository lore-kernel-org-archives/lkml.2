Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab0KVAiv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:38:51 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45577 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab0KVAiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:38:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=aB/ghepbxA+BQkQVWNbJznOtK4pYL4CnjPQnpLAA8y1VzGxdUSLL6zkmS0Fz5+IuQR
         27pMBTXfwF+75gjSSYI9aNHpjHxbr+djwgVriJiiD5kOtmi/JHeGf09QEx4+gml2/6Q4
         DflPlJCv+omFHs0wAVWo005qtcu+6DHzurF10=
MIME-Version: 1.0
In-Reply-To: <20101121173726.GG23423@thunk.org>
References: <20101121112611.GB4267@deepthought.bhanu.net>
	<20101121133024.GF23423@thunk.org>
	<20101121153949.GD20947@barrios-desktop>
	<20101121173726.GG23423@thunk.org>
Date: Mon, 22 Nov 2010 09:38:49 +0900
Message-ID: <AANLkTimeSWWo-TAJPPH81OO_h1zFzWAT1Gg=XSLyFftH@mail.gmail.com>
Subject: Re: [BUG?] [Ext4] INFO: suspicious rcu_dereference_check() usage
From: Minchan Kim <minchan.kim@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Minchan Kim <minchan.kim@gmail.com>,
        linux-ext4@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 2:37 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Nov 22, 2010 at 12:39:49AM +0900, Minchan Kim wrote:
>>
>> I think it's no problem.
>>
>> That's because migration always holds lock_page on the file page.
>> So the page couldn't remove from radix.
>
> It may be "ok" in that it won't cause a race, but it still leaves an
> unsightly warning if LOCKDEP is enabled, and LOCKDEP warnings will
> cause /proc_lock_stat to be disabled.  So I think it still needs to be
> fixed by adding rcu_read_lock()/rcu_read_unlock() to
> migrate_page_move_mapping().
>
>                                                     - Ted
>

Yes. if it is really "ok" about race, we will add rcu_read_lock with
below comment to prevent false positive.
"suppress RCU lockdep false positives".
But I am not sure it's good although rcu_read_lock is little cost.
Whenever we find false positive, should we add rcu_read_lock to
suppress although it's no problem in real product?
Couldn't we provide following function? (or we might have already it
but I missed it. )

/*
 * Suppress RCU lockdep false positive.
 */
#ifdef CONFIG_PROVE_RCU
#define rcu_read_lock_suppress rcu_read_lock
#else
#define rcu_read_lock_suppress
#endif


-- 
Kind regards,
Minchan Kim
