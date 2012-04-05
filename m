Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab2DEXtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:49:35 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46160 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2DEXtd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:49:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <levinsasha928@gmail.com>
Cc: davem <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Van Hensbergen <ericvh@gmail.com>, Dave Jones <davej@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <1333664446.3538.12.camel@lappy>
Date: Thu, 05 Apr 2012 16:53:18 -0700
In-Reply-To: <1333664446.3538.12.camel@lappy> (Sasha Levin's message of "Thu,
	05 Apr 2012 18:20:46 -0400")
Message-ID: <m1aa2pwxap.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18yKZ6jHn7JlrEX1oVKTFZmXg1a7t1Me0Q=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sasha Levin <levinsasha928@gmail.com>
X-Spam-Relay-Country: **
Subject: Re: net: kernel BUG() in net/netns/generic.h:45
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> Hi all,
>
> When an initialization of a network namespace in setup_net() fails, we
> try to undo everything by executing each of the exit callbacks of every
> namespace in the network.
>
> The problem is, it might be possible that the net_generic array wasn't
> initialized before we fail and try to undo everything. At that point,
> some of the networks assume that since we're already calling the exit
> callback, the net_generic structure is initialized and we hit the BUG()
> in net/netns/generic.h:45 .
>
> I'm not quite sure whether the right fix from the following three
> options is, and would be happy to figure it out before fixing it:
>
>  1. Don't assume net_generic was initialized in the exit callback, which
> is a bit problematic since we can't query that nicely anyway (a
> sub-option here would be adding an API to query whether the net_generic
> structure is initialized.
>
>  2. Remove the BUG(), switch it to a WARN() and let each subsystem
> handle the case of NULL on it's own. While it sounds a bit wrong, it's
> worth mentioning that that BUG() was initially added in an attempt to
> fix an issue in CAIF, which was fixed in a completely different way
> afterwards, so it's not strictly necessary here.
>
>  3. Only call the exit callback for subsystems we have called the init
> callback for.

Your option 3 only calling the exit callbacks for subsystems we have
initialized should be what is implemented.  Certainly it looks like we
are attempting to only call the exit callbacks for code whose init
callback has succeeded.

What problem are you seeing?

This smells suspiciously like a problem we had a little while ago caif
was registering as a pernet device instead of a pernet subsystem,
and because of that we had packets flying around after it had been
unregistered and was trying access it's net_generic data.

commit 8a8ee9aff6c3077dd9c2c7a77478e8ed362b96c6
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Thu Jan 26 14:04:53 2012 +0000

    net caif: Register properly as a pernet subsystem.
    
    caif is a subsystem and as such it needs to register with
    register_pernet_subsys instead of register_pernet_device.
    
    Among other problems using register_pernet_device was resulting in
    net_generic being called before the caif_net structure was allocated.
    Which has been causing net_generic to fail with either BUG_ON's or by
    return NULL pointers.
    
    A more ugly problem that could be caused is packets in flight why the
    subsystem is shutting down.
    
    To remove confusion also remove the cruft cause by inappropriately
    trying to fix this bug.
    
    With the aid of the previous patch I have tested this patch and
    confirmed that using register_pernet_subsys makes the failure go away as
    it should.
    
    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
    Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
    Tested-by: Sasha Levin <levinsasha928@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Eric
