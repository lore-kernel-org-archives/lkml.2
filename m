Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab0HaRn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 13:43:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab0HaRn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 13:43:28 -0400
X-Authority-Analysis: v=1.1 cv=tmcEYLAoDqwcE/92ninAvjUMbWeHvL1caymGjnMU8Ns= c=1 sm=0 a=kqxJoFsqNMcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=da-vh-ESf4kec7Yx9T8A:9 a=mwKU9AM7fvunhmKafx6SNMIdNcgA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [Patch] ext4: avoid null dereference
From: Steven Rostedt <rostedt@goodmis.org>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <4C777C04.7080906@cn.fujitsu.com>
References: <4C777C04.7080906@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 Aug 2010 13:43:26 -0400
Message-ID: <1283276606.1377.244.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 16:49 +0800, Wen Congyang wrote:
> ac->inode is set to null in function ext4_mb_release_group_pa(),
> and then trace_ext4_mballoc_discard(ac) is called, the kernel
> will panic.

> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index 01e9e00..6a1fcff 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -796,8 +796,9 @@ DECLARE_EVENT_CLASS(ext4__mballoc,
>  	),
>  
>  	TP_fast_assign(
> -		__entry->dev		= ac->ac_inode->i_sb->s_dev;
> -		__entry->ino		= ac->ac_inode->i_ino;
> +		__entry->dev		= ac->ac_sb->s_dev;
> +		__entry->ino		= ac->ac_inode ?
> +						ac->ac_inode->i_ino : 0;

Is i_ino == 0 a valid inode number?

If not, then

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>  		__entry->result_logical	= ac->ac_b_ex.fe_logical;
>  		__entry->result_start	= ac->ac_b_ex.fe_start;
>  		__entry->result_group	= ac->ac_b_ex.fe_group;


