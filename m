Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab2CFIoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 03:44:01 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29671 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758301Ab2CFIoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 03:44:00 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6640"; a="167386379"
Message-ID: <4F55CE4D.9090408@codeaurora.org>
Date: Tue, 06 Mar 2012 00:43:57 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/2] coccinelle: semantic patch for simple_open()
References: <1330769180-22354-1-git-send-email-sboyd@codeaurora.org> <1330769180-22354-3-git-send-email-sboyd@codeaurora.org> <alpine.DEB.2.02.1203031307080.1780@hadrien>
In-Reply-To: <alpine.DEB.2.02.1203031307080.1780@hadrien>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/12 04:10, Julia Lawall wrote:
>
>
> On Sat, 3 Mar 2012, Stephen Boyd wrote:
>
>> Find instances of an open-coded simple_open() and replace them
>> with calls to simple_open().
>>
>> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>
>> This seems to eat the definition of simple_open() as well. Is there
>> a way to say only remove both the function and the reference to
>> the function so that libfs survives?
>
> Try identifier open_f != simple_open;

Ah thanks. That works.

>
> Is there a header file that should be present?

It would be <include/fs.h> which should already be there if there is a 
file_operations structure.

>
> Your transformation rules should include depends on patch in the very 
> first line, after the rule name.
>
> Can you make a report rule?  If not, I will do it.  Someone asked for 
> that to always be present.

I tried but failed. I get:

nit_defs_builtins: /usr/share/coccinelle/standard.h
between: p start 15 p end 15 m1 start 15 m1 end 15 m2 start 15 m2 end 15

   -int -open:open_f-struct -inode -*-open:i-, -struct -file -*-open:f
Fatal error: exception Failure("The semantic patch is structured in a 
way that may give bad results with isomorphisms.  Please try to rewrite 
it by moving + code out from -/context terms.")

When I add this:

@r1 depends on org || report @
identifier open_f != simple_open;
identifier i, f;
position p1;
@@
  int open_f@p1(struct inode *i, struct file *f)
  {
(
  if (i->i_private)
  f->private_data = i->i_private;
|
  f->private_data = i->i_private;
)
  return 0;
  }

@script:python depends on org@
p1 << r1.p1;
@@

cocci.print_main("extra function",p1)


Any ideas what's wrong?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

