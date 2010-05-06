Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab0EFOYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 10:24:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:34847 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab0EFOYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 10:24:16 -0400
Message-ID: <4BE2D10D.4070706@suse.cz>
Date: Thu, 06 May 2010 16:24:13 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.11 Thunderbird/3.0.4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-arch@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: kbuild: fixing the select problem
References: <1273096160.23208.35.camel@mulgrave.site>
In-Reply-To: <1273096160.23208.35.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.5.2010 23:49, James Bottomley wrote:
> [Sam: I know you don't maintain kbuild anymore, but since you have the
> most experience, if you could find time to comment, I'd be grateful]
> 
> The select problem is that the kbuild select directive will turn a
> symbol on without reference to its dependencies.  This, in turn, means
> that either selected symbols must select their dependencies, or that
> people using select have to be aware of the selected symbol's dependency
> and build those dependencies into their symbol (leading to duplication
> and the possibility of getting the dependencies out of sync).  We use
> select for the scsi transport classes, so we run into this problem in
> SCSI quite a lot.
> 
> I think the correct fix is to make a symbol that selects another symbol
> automatically inherit all of the selected symbol's dependencies.
> 
> There seems to be a fairly easy way to do this in kbuild.  Right at the
> moment, select is handled as additional symbol values as the last point
> in the symbol tree evaluation process.  Instead, what I propose doing is
> for every select symbol, we add an extra unconditional default for the
> selected symbol of the selecting symbol's current value (this breaks a
> possible dependency cycle) and add to the dependencies of the selecting
> symbol, the symbol it's currently selecting.

Nice trick :-).


> There's one wrinkle to all of this in that the current parser for
> default values stops when it finds the first valid (i.e. whose if clause
> evaluates to true) default.  To make the above scheme work, I need to
> modify the default parser so it takes the highest tristate of all the
> valid defaults (and bumps m to y for bool).

We should check if some Kconfig file doesn't rely on this "first hit"
behavior and fix it to explicitly list the condition for a given
default. Another option would be to add
default SYM1 || SYM2
to a symbol selected by SYM1 and SYM2.


> Does this look acceptable to people?  I think it should give the desired
> result and has the added benefit that we can then strip the extra select
> overlay out of the kbuild system (making the parser slightly simpler).
> 
> If this looks like a good idea to people, I think I can code up a quick
> patch.

Other than the above, right now I don't see any issues with such approach.

On a related note, I see Vegard's GSoC project to use a sat solver for
kconfig got accepted [1]. Vegard, how is the project progressing?

[1]
http://socghop.appspot.com/gsoc/student_project/show/google/gsoc2010/psu_home/t127230762803

Michal
