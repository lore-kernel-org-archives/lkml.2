Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab1LRIEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 03:04:11 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50541 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1LRID6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 03:03:58 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        Anca Emanuel <anca.emanuel@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>
References: <CAPLs8y9omncDbLE_KNoKOLLbfwHjWYUJX_i7cC4bLiJsyPbtZQ@mail.gmail.com>
	<m1obv9rkyp.fsf@fess.ebiederm.org>
Date: Sun, 18 Dec 2011 00:05:31 -0800
In-Reply-To: <m1obv9rkyp.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Fri, 16 Dec 2011 00:15:26 -0800")
Message-ID: <m1fwgipano.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX196/38u/To2u0CbSXeAJ310gMcqRxd+LDs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
X-Spam-Relay-Country: **
Subject: Re: v6: faster tree-based sysctl implementation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I spent some time playing this and managed to get something that works
using proc_dir_entries.  And while it is simpler (600 less lines of
code) it takes about 3x the space of just what using ctl_table entries
does.

I managed to prove to myself that the current sysctl infrastructure
relies the union directory existence semantics pretty strongly.  Despite
all of Al's work to the contrary when he introduced attached_by and kin
in sysctl head.

One nice thing I managed to do was to shift around the problem a bit
so that only at /proc/sys/net do we to namespace weirdness.  Which also
considerably simplifies the problem.

Now that I know that normal unix directory semantics are a lost cause
removing the child entry from ctl_table looks like a very productive
exercise.  

Furthermore it feels like the optimal data structure would be a
directory tree that is created on demand as we create entries,
and a second copy of that directory tree that is per network namespace.

That is very similar to the data structure you wound up with.

So in the next little bit I am going to see if I can combine what
you did and what I did and see if I can come up with something that
is obvious in how it works from looking at it's data structures.

Eric
