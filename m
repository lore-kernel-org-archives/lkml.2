Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603Ab2J3XJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 19:09:28 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58003 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759938Ab2J3XJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 19:09:26 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1210262351330.2756@ionos>
References: <CAN8Q1EdobyFuAvtajGRSqNsCG+XoPA+FkwN=2j_H126mmfEjTQ@mail.gmail.com>
	<1350925299.8609.978.camel@edumazet-glaptop>
	<CAN8Q1EeqmHMHD-VUgr7Wzv0Z_DAD1SrEniftg==L14d+hGwu+Q@mail.gmail.com>
	<CAN8Q1EcTRsHjCJD90q0bKRJFMvi7Vn8YRsyQTAHNtTFVuuNdWQ@mail.gmail.com>
	<CAN8Q1EeB2kC6A_YP9zdtp_qYHMG5FF7-Usjx7Rz5pv--bjhqkQ@mail.gmail.com>
	<1351053164.6537.95.camel@edumazet-glaptop>
	<CAN8Q1Ef9sCAG8-KNWXEeuRUcmFNcg93mMG=HRQw6i3UuGtJCVg@mail.gmail.com>
	<1351270087.30380.9.camel@edumazet-glaptop>
	<CAN8Q1Ed1J-jmO9LppcA=rFXPvxFkk-J9mMb2-NhDYyAQKO2jvQ@mail.gmail.com>
	<1351285552.30380.20.camel@edumazet-glaptop>
	<CAN8Q1Ecx-pDR=NBQm4O=VaynQsxBU1wku9e_kcKkWB=xU0OtMA@mail.gmail.com>
	<alpine.LFD.2.02.1210262351330.2756@ionos>
Date: Tue, 30 Oct 2012 16:09:24 -0700
X-Google-Sender-Auth: bkOQg-SH0v4qVa2_tVgTUfmFUww
Message-ID: <CAN8Q1Ef1_OOTpqSrvPB6ja3A3e9-Lky-iceH4NKjWLw8HcW2AA@mail.gmail.com>
Subject: Re: Process Hang in __read_seqcount_begin
From: Peter LaDow <petela@gocougs.wsu.edu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, netfilter@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok.  More of an update.  We've managed to create a scenario that
exhibits the problem much earlier.  We can now cause the lockup to
occur within a few hours (rather than the 12 to 24 hours in our other
scenario).

 Our setup is to to have a a lot of traffic constantly being processed
by the netfilter code.  After about 2 hours, any external attempt to
read the table entries (such as with getsocktopt and
IPT_SO_GET_ENTRIES) triggers the lockup.  What is strange is that this
does not appear until after a couple of hours of heavy traffic.  We
cannot trigger this problem in the first hour, rarely in the second
hour, and always after the second hour.

Now, our original setup did not have as much traffic.  But based upon
a quick, back of the napkin computation, it seems to occurring after a
certain amount of traffic.  I can try to get more firm numbers.  But
this kind of behavior hints less at a race condition between two
writers, and is instead somehow dependent upon the amount of traffic.
Indeed, my test program only uses IPT_SO_GET_ENTRIES which does not
trigger the second path do do_add_counters.  So I'm no longer thinking
the path through setsockopts is a cause of the problem.

So instead, it seems that the only way there could be multiple writers
(assuming that is the problem), is if there are multiple contexts
through which ipt_do_table() is called.  So far, my perusal of the
code indicates only through the hooks in each of the iptables modules.
 And it isn't clear to me how these are called.  But it does seem that
even with the patch Eric provided (which fixes the seqcount update),
there is still a potential problem.

If indeed we have multiple contexts executing ipt_do_table(), it is
possible for more than just the seqcount to be corrupted.  Indeed, it
seems that any updates to the internal structures could cause
problems.  It isn't clear to me if there is anything modified here,
other than the counters, so I'm not sure if there are any other
issues.  But regardless, if the counters could become corrupted, then
it is possible to break any rules that use them.

Anyway, based on earlier discussion, is there any reason not to use a
lock (presuming any solution properly takes into account possible
recursion)?  I understand that the mainline is protected, but perhaps
in the RT version we can use seqlock (and prevent a recursive lock)?

Thanks,
Pete LaDow
