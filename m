Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab1B0Lou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 06:44:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64989 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1B0Lor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 06:44:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m5cGFfIdYFRKX2k2t4TgwHRFM8NBQafaJlzLtXeJ2kfc7k7+cZAy6at+zS+HTzAl1e
         lrcCQclLKNqjqDt4JmfiFzomSfYtqYtt1QGkEqRt+Svizghkv9eV7lVjwxnh/e9tzNju
         qJ3tvdR3mAUZDJNCzK4kkJT/BRs+F3+2guCXo=
Date: Sun, 27 Feb 2011 14:44:38 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: David Miller <davem@davemloft.net>
Cc: bhutchings@solarflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        eric.dumazet@gmail.com, therbert@google.com, xiaosuo@gmail.com,
        jesse@nicira.com, kees.cook@canonical.com, eugene@redhat.com,
        dan.j.rosenberg@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH] don't allow CAP_NET_ADMIN to load non-netdev kernel
 modules
Message-ID: <20110227114438.GA4317@albatros>
References: <20110225190205.GA4541@albatros>
 <20110225.110529.39178636.davem@davemloft.net>
 <1298660879.2554.23.camel@bwh-desktop>
 <20110225.111606.115927805.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225.111606.115927805.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Fri, Feb 25, 2011 at 11:16 -0800, David Miller wrote:
> From: Ben Hutchings <bhutchings@solarflare.com>
> Date: Fri, 25 Feb 2011 19:07:59 +0000
> 
> > You realise that module loading doesn't actually run in the context of
> > request_module(), right?
> 
> Why is that a barrier?  We could simply pass a capability mask into
> request_module if necessary.
> 
> It's an implementation detail, and not a deterrant to my suggested
> scheme.

Let's discuss your scheme.  AFAIU, you suggest to change:


1. a) request_module("%s", devname) =>
request_module_with_caps(CAP_NET_ADMIN, "%s", devname)

   b) call_usermodehelper() => call_usermodehelper_with_caps()

   c) add some bits/sections into kernel module image indicating that
this module is safe to be loaded via CAP_NET_ADMIN

   d) run modprobe with CAP_NET_ADMIN only

   e) in load_module() check whether (the process has CAP_SYS_MODULE) or
(the process has CAP_NET_ADMIN and bit SAFE_NET_MODULE is raised in
the module image)

This obviously doesn't work - the kernel is not able to verify whether
the bit/section is not malformed by user with CAP_NET_ADMIN.


-OR-


1. a) request_module("%s", devname) => request_module_with_argument("--netdev", "%s", devname)

   b) patch modprobe to add "--netmodule-only" argument (or bitmask,
whatever), this would indicate that only net/** modules may be loaded.

Then the things are still broken - a user has to update modprobe
together with the kernel, otherwise the updated kernel would call
"modprobe" with unsupported argument and even "sit0" wouldn't work.


Additionally this touches module loading process, which is not buggy.


Or you propose something else besides these 2 ways?  Please clarify.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
