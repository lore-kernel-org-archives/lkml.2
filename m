Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab2JGPjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:39:39 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:18945
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858Ab2JGPjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:39:20 -0400
X-IronPort-AV: E=Sophos;i="4.80,547,1344204000"; 
   d="scan'208";a="158166836"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, linux-i2c@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, rmallon@gmail.com, shubhrajyoti@ti.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/11] introduce macros for i2c_msg initialization
Date: Sun,  7 Oct 2012 17:38:30 +0200
Message-Id: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces some macros for describing how an i2c_msg is
being initialized.  There are three macros: I2C_MSG_READ, for a read
message, I2C_MSG_WRITE, for a write message, and I2C_MSG_OP, for some other
kind of message, which is expected to be very rarely used.

Some i2c_msg initializations have been updated accordingly using the
following semantic patch:

// <smpl>
@r@
field list[n] ds;
type T;
identifier i;
@@

struct i2c_msg {
  ds
  T i;
  ...
};

@@
initializer list[r.n] is;
expression a;
identifier nm;
identifier r.i;
@@

struct i2c_msg nm = {
  is,
- a
+  .i = a
  ,...
};

@@
initializer list[r.n] is;
expression a;
identifier nm;
identifier r.i;
@@

struct i2c_msg nm[...] = { ..., {
  is,
- a
+  .i = a
  ,...}, ...};

@@
initializer list[r.n] is;
expression a;
identifier nm;
identifier r.i;
@@

struct i2c_msg nm[] = { ..., {
  is,
- a
+  .i = a
  ,...}, ...};

// --------------------------------------------------------------------
// ensure everyone has all fields, pointer case first

@rt@
type T;
identifier i;
@@

struct i2c_msg {
  ...
  T *i;
  ...
};

@t1@
expression e;
identifier nm,rt.i;
position p;
@@

struct i2c_msg nm = {@p
  .i = e,
};

@@
identifier nm,rt.i;
position p!= t1.p;
@@

struct i2c_msg nm = {@p
+ .i = NULL,
  ...
};

@t2@
expression e;
identifier nm,rt.i;
position p;
@@

struct i2c_msg nm[] = { ..., {@p
  .i = e,
}, ...};

@@
identifier nm,rt.i;
position p!= t2.p;
@@

struct i2c_msg nm[] = { ..., {@p
+ .i = NULL,
  ...
}, ...};

@t3@
expression e;
identifier nm,rt.i;
position p;
@@

struct i2c_msg nm[...] = { ..., {@p
  .i = e,
}, ...};

@@
identifier nm,rt.i;
position p!= t3.p;
@@

struct i2c_msg nm[...] = { ..., {@p
+ .i = NULL,
  ...
}, ...};

// ---------------------------------

@f1@
expression e;
identifier nm,r.i;
position p;
@@

struct i2c_msg nm = {@p
  .i = e,
};

@@
identifier nm,r.i;
position p!= f1.p;
@@

struct i2c_msg nm = {@p
+ .i = 0,
  ...
};

@f2@
expression e;
identifier nm,r.i;
position p;
@@

struct i2c_msg nm[] = { ..., {@p
  .i = e,
}, ...};

@@
identifier nm,r.i;
position p!= f2.p;
@@

struct i2c_msg nm[] = { ..., {@p
+ .i = 0,
  ...
}, ...};

@f3@
expression e;
identifier nm,r.i;
position p;
@@

struct i2c_msg nm[...] = { ..., {@p
  .i = e,
}, ...};

@@
identifier nm,r.i;
position p!= f3.p;
@@

struct i2c_msg nm[...] = { ..., {@p
+ .i = 0,
  ...
}, ...};

// --------------------------------------------------------------------

@@
constant c;
identifier x;
type T,T1;
T[] b;
@@

struct i2c_msg x =
  { .buf = \((T1)b\|(T1)(&b)\|(T1)(&b[0])\), .len =
(
0
|
  sizeof (...)
|
- c
+ sizeof(b)
)
  };

@@
constant c;
identifier x;
type T,T1;
T[] b;
@@

struct i2c_msg x[...] =  {...,
  { .buf = \((T1)b\|(T1)(&b)\|(T1)(&b[0])\), .len =
(
0
|
  sizeof (...)
|
- c
+ sizeof(b)
)
  } ,...};

@@
constant c;
identifier x;
type T,T1;
T[] b;
@@

struct i2c_msg x[] =  {...,
  { .buf = \((T1)b\|(T1)(&b)\|(T1)(&b[0])\), .len =
(
0
|
  sizeof (...)
|
- c
+ sizeof(b)
)
  } ,...};

@@
constant c;
identifier x;
type T1;
expression b;
@@

struct i2c_msg x =
  { .buf = (T1)(&b), .len =
(
0
|
  sizeof (...)
|
- c
+ sizeof(b)
)
  };

@@
constant c;
identifier x;
type T1;
expression b;
@@

struct i2c_msg x[...] =  {...,
  { .buf = (T1)(&b), .len =
(
0
|
  sizeof (...)
|
- c
+ sizeof(b)
)
  } ,...};

@@
constant c;
identifier x;
type T1;
expression b;
@@

struct i2c_msg x[] =  {...,
  { .buf = (T1)(&b), .len =
(
0
|
  sizeof (...)
|
- c
+ sizeof(b)
)
  } ,...};

// --------------------------------------------------------------------

@@
expression a,b,c;
identifier x;
@@

struct i2c_msg x =
- {.addr = a, .buf = b, .len = c, .flags = I2C_M_RD}
+ I2C_MSG_READ(a,b,c)
 ;

@@
expression a,b,c;
identifier x;
@@

struct i2c_msg x =
- {.addr = a, .buf = b, .len = c, .flags = 0}
+ I2C_MSG_WRITE(a,b,c)
 ;

// has to come before the next rule, which matcher fewer fields
@@
expression a,b,c,d;
identifier x;
@@

struct i2c_msg x = 
- {.addr = a, .buf = b, .len = c, .flags = d}
+ I2C_MSG_OP(a,b,c,d)
 ;

// --------------------------------------------------------------------

@@
expression a,b,c;
identifier x;
@@

struct i2c_msg x[] = {...,
- {.addr = a, .buf = b, .len = c, .flags = I2C_M_RD}
+ I2C_MSG_READ(a,b,c)
 ,...};

@@
expression a,b,c;
identifier x;
@@

struct i2c_msg x[] = {..., 
- {.addr = a, .buf = b, .len = c, .flags = 0}
+ I2C_MSG_WRITE(a,b,c)
 ,...};

@@
expression a,b,c,d;
identifier x;
@@

struct i2c_msg x[] =  {...,
- {.addr = a, .buf = b, .len = c, .flags = d}
+ I2C_MSG_OP(a,b,c,d)
 ,...};

// --------------------------------------------------------------------

@@
expression a,b,c;
identifier x;
@@

struct i2c_msg x[...] =  {...,
- {.addr = a, .buf = b, .len = c, .flags = I2C_M_RD}
+ I2C_MSG_READ(a,b,c)
 ,...};

@@
expression a,b,c;
identifier x;
@@

struct i2c_msg x[...] =  {...,
- {.addr = a, .buf = b, .len = c, .flags = 0}
+ I2C_MSG_WRITE(a,b,c)
 ,...};

@@
expression a,b,c,d;
identifier x;
@@

struct i2c_msg x[...] = {...,
- {.addr = a, .buf = b, .len = c, .flags = d}
+ I2C_MSG_OP(a,b,c,d)
 ,...};

// --------------------------------------------------------------------
// got everything?

@check1@
identifier nm;
position p;
@@

struct i2c_msg nm@p = {...};

@script:python@
p << check1.p;
@@

cocci.print_main("",p)

@check2@
identifier nm;
position p;
@@

struct i2c_msg nm@p [] = {...,{...},...};

@script:python@
p << check2.p;
@@

cocci.print_main("",p)

@check3@
identifier nm;
position p;
@@

struct i2c_msg nm@p [...] = {...,{...},...};

@script:python@
p << check3.p;
@@

cocci.print_main("",p)
// </smpl>


