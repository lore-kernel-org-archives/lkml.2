Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0ELIts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:49:48 -0400
Received: from www84.your-server.de ([213.133.104.84]:54492 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab0ELItp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:49:45 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       andi@firstfloor.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       tytso@mit.edu, iws@ovro.caltech.edu
Cc: stefani@seibold.net
Subject: really generic, type save and type definable. 
Date: Wed, 12 May 2010 10:49:23 +0200
Message-Id: <1273654167-31067-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.0.4
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API is still stable, no code which use the current  kfifo API must 
be modified!

Here are the results of the text section usage:

Example 1:
                        kfifo_put/_get  kfifo_in/out    current kfifo
dynamic allocated       0x000002a8      0x00000291      0x00000299
in place                0x00000291      0x0000026e      0x00000273

kfifo.c                 new             old
text section size       0x00000be5      0x000008b2

As you can see, kfifo_put/kfifo_get creates a little bit more code than 
kfifo_in/kfifo_out, but it is much faster (the code is inline).

The code is complete hand crafted and optimized. The text section size is as 
small as possible. You get all the fifo handling in only 3 kb. This includes 
type safe fix size records, dynamic records and DMA handling.

This should be the final version. All requested features are implemented.

Note: Most features of this API doesn't have any users. All functions which
are not used in the next 9 months will be removed. So, please adapt your
drivers and other sources as soon as possible to the new API and post it. 

This are the features which are currently not used in the kernel:

kfifo_to_user()
kfifo_from_user()
kfifo_dma_....() macros
kfifo_esize()
kfifo_recsize()
kfifo_put()
kfifo_get()
the fixed size record elements, exclude "unsigned char" fifo's and
the variable size records fifo's

ChangeLog:

12.05.2010 Sync with kernel 2.6.34-rc7
20.04.2010 Fix possible break of the kernel build by the patch sequence
18.04.2010 Sync with kernel 2.6.34-rc4
12.02.2010 Sync with kernel 2.6.33-rc7
           Add example code to the kernel sample directory
           Make more exact comments for the kerneldoc tools
           Split the patch
05.02.2010 Sync with kernel 2.6.33-rc6
           Fix comments for the kerneldoc tools
           Fix kernel-api.tmpl
           Checked with sparse
           Tested and analize with gcc-3.4.6
           Fix INIT_KFIFO to create better code
           make checkpath.pl clean
           add some comments for better understanding the code
           rename kfifo_out_locked() into kfifo_out_spinlocked() and add an
           alias kfifo_out_locked() for kfifo_out_spinlocked() which will be
           removed in future.
           Did the same for kfifo_in_locked()
           Fix kfifo_free to free the fifo buffer, not the fifo structure
           Add all fixes suggested by Andrew Morton
           Modify test1.c sample code
27.01.2010 renamed kfifo_sizeof into kfifo_esize
           code refactoring: shrink foot print 
           fix bugs
           changed all 0 pointer into NULL
           fix a miss use in drivers/char/nozomi.c
           enhanced DMA functions to handle a non continues fifo buffer (e.g. vmalloc)
           reintroduced record dynamic handling as requested (tried to implemented it 
           separately, but this will double the code)
           Sync with kernel 2.6.33-rc5           
16.01.2010 Kicked away dynamic record handling. If anybody want it please let me know.
           Add a esize field which represents the size of the element stored in
           the fifo. This will increase the size of the fifo stucture by 4 bytes 
           but obtain a smaller code.
           Generalized the kfifo.c funtions to handle byte and all other element 
           sizes in common functions.
           Shrink the code size of kfifo.c from 2k to 1k
           Code cleanup
15.01.2010 fix kfifo_dma_*() bugs
           add a DMA usage exmaple
           fix kfifo_free()
           prevent creation of fifo with less then 2 entries
           prevent a real in place fifo manipulation with kfifo_alloc(), 
           kfifo_init() or kfifo_free()
           make INIT_KFIFO save with a dynamic allocated fifo
14.01.2010 Change the size field of the fifo structure into a mask field, which
           is size - 1. This will save some instructions 
           Make the basic structure mode generic. Add a data pointer and mask
           field, also for real in place fifo, because the extra function parameter
           passing of the data pointer and and the fifo size was to costly
           Change all internal functions to work with the generic base structure
           Optimized the kfifo_put and kfifo_get macros to prevent an indirection
           Code cleanup
           Bug fixes in kfifo_dma_* macros
           Update examples
           Sync with kernel 2.6.33-rc4
06.01.2010 Add a note about locking: clarify when locking is needed
           Fix byte stream example
           Remove unnecessary typedefs
           Make checkpatch.pl clean: one error left, but there is no way to
           solve this...
28.12.2009 Sanitize kfifo_*_user() error handling (suggested by Andi Kleen)
           kfifo_from_user() and kfifo_to_user() will now return an error
           code and the number of copied bytes will be stored in a variable
           passed as pointer
           Make patch readable
           Update examples
           Fix a typo
27.12.2009 Sync with kernel 2.6.33-rc2
           Introduce new kfifo_initialized macro (suggested by Andi Kleen)
           Renamed kfifo_peek into kfifo_peek_len
           Introduce new kfifo_peek macro (suggest by Andi Kleen)
           Introduce new kfifo_out_peek macro (suggested by Andi Kleen)
           Fix broken kernel-doc notation
           Fix samples
21.12.2009 Fix checkpatch.pl, fix samples
20.12.2009 Bug fixing
           Fix samples
19.12.2009 First draft
13.12.2009 First implementation of a type safe fifo implementation, called kqueue

There are different types of a fifo which can not handled in C without a
lot of overhead. So i decided to write the API as a set of macros, which 
is the only way to do a kind of template meta programming without C++. 
This macros handles the different types of fifos in a transparent way.

There are a lot of benefits:

- Compile time handling of the different fifo types
- Better performance (a save put or get of an integer does only generate 
  9 assembly instructions on a x86) 
- Type save
- Cleaner interface, the additional kfifo_..._rec() functions are gone
- Easier to use
- Less error prone
- Different types of fifos: it is now possible to define a int fifo or
  any other type. See below for an example.
- Smaller footprint for none byte type fifos
- No need of creating a second hidden variable, like in the old DEFINE_KFIFO

The API was not changed.

There are now real in place fifos where the data space is a part of the 
structure. The fifo needs now 20 byte plus the fifo space. Dynamic 
assigned or allocated create a little bit more code.

Most of the macros code will be optimized away and simple generate a 
function call. Only the really small one generates inline code.

Additional you can now create fifos for any data type, not only the
"unsigned char" byte streamed fifos.

There is also a new kfifo_put and kfifo_get function, to handle a single
element in a fifo. This macros generates inline code, which is lit bit
larger but faster.

I know that this kind of macros are very sophisticated and not easy to
maintain. But i have all tested and it works as expected. I analyzed the
output of the compiler and for the x86 the code is as good as hand
written assembler code. For the byte stream fifo the generate code is exact 
the same as with the current kfifo implementation. For all other types of
fifos the code is smaller before, because the interface is easier to use. 

The main goal was to provide an API which is very intuitive, save and easy
to use. So linux will get now a powerful fifo API which provides all what 
a developer needs. This will save in the future a lot of kernel space, since
there is no need to write an own implementation. Most of the device driver 
developers need a fifo, and also deep kernel development will gain benefit 
from this API.

This code is ready for merge into the mm tree or linux next. Please review 
it and merge.

Stefani
