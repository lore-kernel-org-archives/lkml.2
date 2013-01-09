Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab3AIUdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:33:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab3AIUdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:33:05 -0500
Message-ID: <1357763560.1342.7.camel@localhost>
Subject: Re: Friendlier EPERM - Request for input
From: Eric Paris <eparis@redhat.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, dwalsh@redhat.com,
        dmalcolm@redhat.com, sds@tycho.nsa.gov, segoon@openwall.com,
        linux-security-module@vger.kernel.org
Date: Wed, 09 Jan 2013 15:32:40 -0500
In-Reply-To: <50EDCFC0.3010401@schaufler-ca.com>
References: <1357747463.2593.28.camel@localhost>
	 <1357760637.2593.55.camel@localhost> <50EDCFC0.3010401@schaufler-ca.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 12:14 -0800, Casey Schaufler wrote:
> On 1/9/2013 11:43 AM, Eric Paris wrote:

> > I know many people are worried about information leaks, so I'll right up
> > front say lets add the sysctl to disable the interface for those who are
> > concerned about the metadata information leak.  But for most of us I
> > want that data right when it happens, where it happens, so It can be
> > exposed, used, and acted upon by the admin trying to troubleshoot why
> > the shit just hit the fan.
> 
> How on earth is your webadmin supposed to match the failure
> of a system call with the content of /proc/8675309/whydiditfail
> at the time of the failure? It's not like he's going to go into
> the apache source and add code to look at what's there.
> 
> Unfortunately, what you probably need is an interface that gives
> the program access to the audit records it has generated.

The first thought was wanting to add it by default to perror/strerror in
libc, but libc guys didn't think it reasonable since it couldn't be
save/restored across calls, like errno.  Instead I hope for a libc
function, something like char *get_extended_error_info(void), which
outputs a localized string based on the information in the /proc
interface.

Programs like httpd would need to be changed to use this function when
logging denials.  Programs like python would use this interface to
populate additional information in the exception they pass up the stack.

I agree that something access to the audit record is appropriate.  It's
sorta like what I'm proposing.  But audit is not really useful here.  It
doesn't collect information about any denial other than LSM.  And the
number of DAC or capabilities denials on a normally operating box is, I
expect, quite large.  Thus we can't pump them all into audit just on the
unlikely chance something cares.  Setting a couple of ints is cheap.
Audit is really nice for people will well defined security goals and
information retention and analysis purposes, but it kinda completely
sucks butt for a normal sysadmin or developer...

-Eric

