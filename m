Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab1COPxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 11:53:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:56593 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab1COPxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 11:53:36 -0400
Subject: Re: [PATCH 1/4] drivers/serial/ucc_uart.c: Add of_node_put to avoid memory leak
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1283269738-14612-2-git-send-email-julia@diku.dk>
Date: Tue, 15 Mar 2011 10:51:23 -0500
Cc: Timur Tabi <timur@freescale.com>, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2452483F-04B7-4B44-B59D-94A9D18F5DA4@kernel.crashing.org>
References: <1283269738-14612-1-git-send-email-julia@diku.dk> <1283269738-14612-2-git-send-email-julia@diku.dk>
To: Julia Lawall <julia@diku.dk>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 31, 2010, at 10:48 AM, Julia Lawall wrote:

> Add a call to of_node_put in the error handling code following a call to
> of_find_compatible_node or of_find_node_by_type.
> 
> This patch also substantially reorganizes the error handling code in the
> function, to that it is possible first to jump to code that frees qe_port
> and then to jump to code that also puts np.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> expression E,E1,E2;
> statement S;
> @@
> 
> *x = 
> (of_find_node_by_path
> |of_find_node_by_name
> |of_find_node_by_phandle
> |of_get_parent
> |of_get_next_parent
> |of_get_next_child
> |of_find_compatible_node
> |of_match_node
> |of_find_node_by_type
> |of_find_node_with_property
> |of_find_matching_node
> |of_parse_phandle
> )(...);
> ...
> if (x == NULL) S
> <... when != x = E
> *if (...) {
>  ... when != of_node_put(x)
>      when != if (...) { ... of_node_put(x); ... }
> (
>  return <+...x...+>;
> |
> *  return ...;
> )
> }
> ...>
> (
> E2 = x;
> |
> of_node_put(x);
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> drivers/serial/ucc_uart.c |   67 ++++++++++++++++++++++++----------------------
> 1 file changed, 35 insertions(+), 32 deletions(-)

applied

- k