Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1EPKii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:38:38 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:32167 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754661Ab1EPKig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:38:36 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: <linux-kernel@vger.kernel.org>, <toshiharu-linux@dsn.okisemi.com>
References: <F9B588C24C5F470494D57D4EFFB14C6B@hacdom.okisemi.com> <4DAFE62A.105@metafoo.de> <20110421134524.GA32725@ponder.secretlab.ca> <4DB03A4B.9040807@metafoo.de> <20110421142422.GC32725@ponder.secretlab.ca> <4C95BE12C2D7458E9D2B54E7C30F712F@hacdom.okisemi.com> <4DB2A6A2.90803@metafoo.de> <614E530848124206BD1A074548078FA8@hacdom.okisemi.com> <FF5A4B77828A4F1AA77531640E8B37FF@hacdom.okisemi.com> <4DCAE163.2050602@metafoo.de> <CCD653B68482426EA47A12055C9E19E5@hacdom.okisemi.com> <4DCC384B.1020202@metafoo.de> <CA2B589B92704A439D8DF3E2EAD9750D@hacdom.okisemi.com> <4DCCA317.2030302@metafoo.de>
Subject: RE: Question: GPIO driver how to get irq_base
Date: Mon, 16 May 2011 19:38:32 +0900
Message-ID: <A3F1E9CB89D548289E8FC5BE11CB67C7@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_00EF_01CC1400.D7CE2A70"
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: AcwRHItBN20Rb4i8QSKgUhat4UZQ/gClEkQg
In-Reply-To: <4DCCA317.2030302@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_00EF_01CC1400.D7CE2A70
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

Pch_gpio driver can become detecting falling/rising edge.
I attached the latest GPIO driver, usermode TP and the result.

However, "poll( )" of gpio_tp behavior is different than I anticipated. 
The "poll" is not blocked. (The returned value looks good)

My anticipated behavior is 
  Execute gpio_tp (blocked at poll( ))
  (Detect edge)
  Interrupt handler of pch_gpio is called
  Blocked poll( ) becomes released.

Let me know your opinion.

With Best Regards,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

------=_NextPart_000_00EF_01CC1400.D7CE2A70
Content-Type: text/plain;
	name="gpio_tp.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="gpio_tp.c"

#include <stdio.h>=0A=
#include <unistd.h>=0A=
#include <poll.h>=0A=
#include <fcntl.h>=0A=
#define GPIO_DIR "/sys/class/gpio"=0A=
#define GPIO_NAME "gpio246"=0A=
#define GPIO_PATH GPIO_DIR "/" GPIO_NAME "/"=0A=
int main(void)=0A=
{=0A=
	int fd;=0A=
	int i;=0A=
	int ret;=0A=
	fd =3D open(GPIO_PATH "direction", O_RDWR);=0A=
	printf("fd=3D%d\n", fd);=0A=
	ret =3D write(fd, "in", 2);=0A=
	printf("write=3D%d\n", ret);=0A=
	close(fd);=0A=
	fd =3D open(GPIO_PATH "edge", O_RDWR);=0A=
	printf("fd=3D%d\n", fd);=0A=
//	ret=3Dwrite(fd, "rising", 6);=0A=
	ret=3Dwrite(fd, "falling", 7);=0A=
	printf("write=3D%d\n", ret);=0A=
	close(fd);=0A=
	for (i=3D0; i < 3; i++) {=0A=
		char val;=0A=
		struct pollfd pfd;=0A=
		fd =3D open(GPIO_PATH "value", O_RDWR);=0A=
		printf("fd=3D%d\n", fd);=0A=
=0A=
		ret=3Dread(fd, &val, 1);=0A=
		printf("read=3D%d val=3D%c\n", ret, val);=0A=
		printf("waiting for interrupt..."); fflush(stdout);=0A=
		pfd.fd =3D fd;=0A=
		pfd.events =3D POLLIN;=0A=
		pfd.revents =3D 0;=0A=
		ret =3D poll(&pfd, 1, -1);=0A=
		printf("poll=3D%d revent=3D0x%x\n", ret, pfd.revents);=0A=
		ret=3Dlseek(fd, 0, SEEK_SET);=0A=
		printf("lseek=3D%d\n", ret);=0A=
		ret =3D read(fd, &val, 1);=0A=
		printf("read=3D%d val=3D%c\n", ret, val);=0A=
		close(fd);=0A=
		printf("OK (%c, %s)\n", val, val =3D=3D '0' ? "Low" : "High");=0A=
		usleep(100000);=0A=
	}=0A=
	return 0;=0A=
}=0A=

------=_NextPart_000_00EF_01CC1400.D7CE2A70
Content-Type: text/plain;
	name="pch_gpio.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="pch_gpio.c"

/*=0A=
 * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.=0A=
 *=0A=
 * This program is free software; you can redistribute it and/or modify=0A=
 * it under the terms of the GNU General Public License as published by=0A=
 * the Free Software Foundation; version 2 of the License.=0A=
 *=0A=
 * This program is distributed in the hope that it will be useful,=0A=
 * but WITHOUT ANY WARRANTY; without even the implied warranty of=0A=
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the=0A=
 * GNU General Public License for more details.=0A=
 *=0A=
 * You should have received a copy of the GNU General Public License=0A=
 * along with this program; if not, write to the Free Software=0A=
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, =
USA.=0A=
 */=0A=
#include <linux/kernel.h>=0A=
#include <linux/pci.h>=0A=
#include <linux/gpio.h>=0A=
#include <linux/interrupt.h>=0A=
#include <linux/irq.h>=0A=
=0A=
#define PCH_GPIO_ALL_PINS	0xfff /* Mask for GPIO pins 0 to 11 */=0A=
#define GPIO_NUM_PINS	12	/* Specifies number of GPIO PINS GPIO0-GPIO11 */=0A=
=0A=
#define PCH_EDGE_FALLING	0=0A=
#define PCH_EDGE_RISING		BIT(0)=0A=
#define PCH_LEVEL_L		BIT(1)=0A=
#define PCH_LEVEL_H		(BIT(0) | BIT(1))=0A=
#define PCH_EDGE_BOTH		BIT(2)=0A=
#define PCH_IM_MASK		(BIT(0) | BIT(1) | BIT(2))=0A=
=0A=
#define PCH_IRQ_BASE		20=0A=
=0A=
struct pch_regs {=0A=
	u32	ien;=0A=
	u32	istatus;=0A=
	u32	idisp;=0A=
	u32	iclr;=0A=
	u32	imask;=0A=
	u32	imaskclr;=0A=
	u32	po;=0A=
	u32	pi;=0A=
	u32	pm;=0A=
	u32	im0;=0A=
	u32	im1;=0A=
	u32	reserved[4];=0A=
	u32	reset;=0A=
};=0A=
=0A=
/**=0A=
 * struct pch_gpio_reg_data - The register store data.=0A=
 * @po_reg:	To store contents of PO register.=0A=
 * @pm_reg:	To store contents of PM register.=0A=
 */=0A=
struct pch_gpio_reg_data {=0A=
	u32 po_reg;=0A=
	u32 pm_reg;=0A=
};=0A=
=0A=
/**=0A=
 * struct pch_gpio - GPIO private data structure.=0A=
 * @base:			PCI base address of Memory mapped I/O register.=0A=
 * @reg:			Memory mapped PCH GPIO register list.=0A=
 * @dev:			Pointer to device structure.=0A=
 * @gpio:			Data for GPIO infrastructure.=0A=
 * @pch_gpio_reg:		Memory mapped Register data is saved here=0A=
 *				when suspend.=0A=
 * @lock:			spin_lock variable=0A=
 */=0A=
struct pch_gpio {=0A=
	void __iomem *base;=0A=
	struct pch_regs __iomem *reg;=0A=
	struct device *dev;=0A=
	struct gpio_chip gpio;=0A=
	struct pch_gpio_reg_data pch_gpio_reg;=0A=
	struct mutex lock;=0A=
	int irq_base;=0A=
	spinlock_t spinlock;=0A=
};=0A=
=0A=
static void pch_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)=0A=
{=0A=
	u32 reg_val;=0A=
	struct pch_gpio *chip =3D	container_of(gpio, struct pch_gpio, gpio);=0A=
=0A=
	mutex_lock(&chip->lock);=0A=
	reg_val =3D ioread32(&chip->reg->po);=0A=
	if (val)=0A=
		reg_val |=3D (1 << nr);=0A=
	else=0A=
		reg_val &=3D ~(1 << nr);=0A=
=0A=
	iowrite32(reg_val, &chip->reg->po);=0A=
	mutex_unlock(&chip->lock);=0A=
}=0A=
=0A=
static int pch_gpio_get(struct gpio_chip *gpio, unsigned nr)=0A=
{=0A=
	struct pch_gpio *chip =3D	container_of(gpio, struct pch_gpio, gpio);=0A=
=0A=
	return ioread32(&chip->reg->pi) & (1 << nr);=0A=
}=0A=
=0A=
static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,=0A=
				     int val)=0A=
{=0A=
	struct pch_gpio *chip =3D	container_of(gpio, struct pch_gpio, gpio);=0A=
	u32 pm;=0A=
	u32 reg_val;=0A=
=0A=
	mutex_lock(&chip->lock);=0A=
	pm =3D ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS;=0A=
	pm |=3D (1 << nr);=0A=
	iowrite32(pm, &chip->reg->pm);=0A=
=0A=
	reg_val =3D ioread32(&chip->reg->po);=0A=
	if (val)=0A=
		reg_val |=3D (1 << nr);=0A=
	else=0A=
		reg_val &=3D ~(1 << nr);=0A=
	iowrite32(reg_val, &chip->reg->po);=0A=
=0A=
	mutex_unlock(&chip->lock);=0A=
=0A=
	return 0;=0A=
}=0A=
=0A=
static int pch_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)=0A=
{=0A=
	struct pch_gpio *chip =3D	container_of(gpio, struct pch_gpio, gpio);=0A=
	u32 pm;=0A=
=0A=
	mutex_lock(&chip->lock);=0A=
	pm =3D ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS; /*bits 0-11*/=0A=
	pm &=3D ~(1 << nr);=0A=
	iowrite32(pm, &chip->reg->pm);=0A=
	mutex_unlock(&chip->lock);=0A=
=0A=
	return 0;=0A=
}=0A=
=0A=
/*=0A=
 * Save register configuration and disable interrupts.=0A=
 */=0A=
static void pch_gpio_save_reg_conf(struct pch_gpio *chip)=0A=
{=0A=
	chip->pch_gpio_reg.po_reg =3D ioread32(&chip->reg->po);=0A=
	chip->pch_gpio_reg.pm_reg =3D ioread32(&chip->reg->pm);=0A=
}=0A=
=0A=
/*=0A=
 * This function restores the register configuration of the GPIO device.=0A=
 */=0A=
static void pch_gpio_restore_reg_conf(struct pch_gpio *chip)=0A=
{=0A=
	/* to store contents of PO register */=0A=
	iowrite32(chip->pch_gpio_reg.po_reg, &chip->reg->po);=0A=
	/* to store contents of PM register */=0A=
	iowrite32(chip->pch_gpio_reg.pm_reg, &chip->reg->pm);=0A=
}=0A=
=0A=
static int pch_gpio_to_irq(struct gpio_chip *gpio, unsigned offset)=0A=
{=0A=
	struct pch_gpio *chip =3D	container_of(gpio, struct pch_gpio, gpio);=0A=
	return chip->irq_base + offset;=0A=
}=0A=
=0A=
static void pch_gpio_setup(struct pch_gpio *chip)=0A=
{=0A=
	struct gpio_chip *gpio =3D &chip->gpio;=0A=
=0A=
	gpio->label =3D dev_name(chip->dev);=0A=
	gpio->owner =3D THIS_MODULE;=0A=
	gpio->direction_input =3D pch_gpio_direction_input;=0A=
	gpio->get =3D pch_gpio_get;=0A=
	gpio->direction_output =3D pch_gpio_direction_output;=0A=
	gpio->set =3D pch_gpio_set;=0A=
	gpio->dbg_show =3D NULL;=0A=
	gpio->base =3D -1;=0A=
	gpio->ngpio =3D GPIO_NUM_PINS;=0A=
	gpio->can_sleep =3D 0;=0A=
	gpio->to_irq =3D pch_gpio_to_irq;=0A=
}=0A=
=0A=
static int pch_irq_type(unsigned irq, unsigned type)=0A=
{=0A=
	u32 im;=0A=
	u32 *im_reg;=0A=
	u32 ien;=0A=
	u32 im_pos;=0A=
	int ch;=0A=
	unsigned long flags;=0A=
	u32 val;=0A=
	struct pch_gpio *chip =3D get_irq_chip_data(irq);=0A=
=0A=
	ch =3D irq - chip->irq_base;=0A=
	if (irq <=3D chip->irq_base + 7) {=0A=
		im_reg =3D &chip->reg->im0;=0A=
		im_pos =3D ch;=0A=
	} else {=0A=
		im_reg =3D &chip->reg->im1;=0A=
		im_pos =3D ch - 8;=0A=
	}=0A=
	dev_dbg(chip->dev, "%s:irq=3D%d type=3D%d ch=3D%d pos=3D%d\n",=0A=
		__func__, irq, type, ch, im_pos);=0A=
=0A=
	spin_lock_irqsave(&chip->spinlock, flags);=0A=
=0A=
	if (type =3D=3D IRQ_TYPE_EDGE_RISING)=0A=
		val =3D PCH_EDGE_RISING;=0A=
	else if (type =3D=3D IRQ_TYPE_EDGE_FALLING)=0A=
		val =3D PCH_EDGE_FALLING;=0A=
	else if (type =3D=3D IRQ_TYPE_EDGE_BOTH)=0A=
		val =3D PCH_EDGE_BOTH;=0A=
	else if (type =3D=3D IRQ_TYPE_LEVEL_HIGH)=0A=
		val =3D PCH_LEVEL_L;=0A=
	else if (type =3D=3D IRQ_TYPE_LEVEL_LOW)=0A=
		val =3D PCH_LEVEL_H;=0A=
	else if (type =3D=3D IRQ_TYPE_PROBE)=0A=
		goto end;=0A=
	else {=0A=
		dev_warn(chip->dev, "%s: unknown type(%dd)", __func__, type);=0A=
		goto end;=0A=
	}=0A=
=0A=
	/* Set interrupt mode */=0A=
	im =3D ioread32(im_reg) & ~(PCH_IM_MASK << (im_pos * 4));=0A=
	iowrite32(im | (val << (im_pos * 4)), im_reg);=0A=
=0A=
	/* iclr */=0A=
	iowrite32(BIT(ch), &chip->reg->iclr);=0A=
=0A=
	/* IMASKCLR */=0A=
	iowrite32(BIT(ch), &chip->reg->imaskclr);=0A=
=0A=
	/* Enable interrupt */=0A=
	ien =3D ioread32(&chip->reg->ien);=0A=
	iowrite32(ien | BIT(ch), &chip->reg->ien);=0A=
end:=0A=
	spin_unlock_irqrestore(&chip->spinlock, flags);=0A=
=0A=
	return 0;=0A=
}=0A=
=0A=
static void pch_irq_unmask(unsigned irq)=0A=
{=0A=
}=0A=
=0A=
static void pch_irq_mask(unsigned irq)=0A=
{=0A=
}=0A=
=0A=
static struct irq_chip pch_irqchip =3D {=0A=
	.name		=3D "PCH-GPIO",=0A=
	.mask		=3D pch_irq_mask,=0A=
	.unmask		=3D pch_irq_unmask,=0A=
	.set_type	=3D pch_irq_type,=0A=
};=0A=
=0A=
static irqreturn_t pch_gpio_handler(int irq, void *dev_id)=0A=
{=0A=
	struct pch_gpio *chip =3D dev_id;=0A=
	u32 reg_val =3D ioread32(&chip->reg->istatus);=0A=
	int i;=0A=
	int ret =3D IRQ_NONE;=0A=
=0A=
	for (i =3D 0; i < GPIO_NUM_PINS; i++) {=0A=
		if (reg_val & BIT(i)) {=0A=
			dev_dbg(chip->dev, "%s:[%d]:irq=3D%d  status=3D0x%x\n",=0A=
				__func__, i, irq, reg_val);=0A=
			iowrite32(BIT(i), &chip->reg->iclr);=0A=
			generic_handle_irq(chip->irq_base + i);=0A=
			ret =3D IRQ_HANDLED;=0A=
		}=0A=
	}=0A=
	return ret;=0A=
}=0A=
=0A=
static int __devinit pch_gpio_probe(struct pci_dev *pdev,=0A=
				    const struct pci_device_id *id)=0A=
{=0A=
	s32 ret;=0A=
	struct pch_gpio *chip;=0A=
	int irq_base;=0A=
	int i;=0A=
=0A=
	chip =3D kzalloc(sizeof(*chip), GFP_KERNEL);=0A=
	if (chip =3D=3D NULL)=0A=
		return -ENOMEM;=0A=
=0A=
	chip->dev =3D &pdev->dev;=0A=
	ret =3D pci_enable_device(pdev);=0A=
	if (ret) {=0A=
		dev_err(&pdev->dev, "%s : pci_enable_device FAILED", __func__);=0A=
		goto err_pci_enable;=0A=
	}=0A=
=0A=
	ret =3D pci_request_regions(pdev, KBUILD_MODNAME);=0A=
	if (ret) {=0A=
		dev_err(&pdev->dev, "pci_request_regions FAILED-%d", ret);=0A=
		goto err_request_regions;=0A=
	}=0A=
=0A=
	chip->base =3D pci_iomap(pdev, 1, 0);=0A=
	if (chip->base =3D=3D 0) {=0A=
		dev_err(&pdev->dev, "%s : pci_iomap FAILED", __func__);=0A=
		ret =3D -ENOMEM;=0A=
		goto err_iomap;=0A=
	}=0A=
=0A=
	chip->reg =3D chip->base;=0A=
	pci_set_drvdata(pdev, chip);=0A=
	mutex_init(&chip->lock);=0A=
	pch_gpio_setup(chip);=0A=
	ret =3D gpiochip_add(&chip->gpio);=0A=
	if (ret) {=0A=
		dev_err(&pdev->dev, "PCH gpio: Failed to register GPIO\n");=0A=
		goto err_gpiochip_add;=0A=
	}=0A=
=0A=
	irq_base =3D irq_alloc_descs(-1, PCH_IRQ_BASE, GPIO_NUM_PINS, =
GFP_KERNEL);=0A=
	if (irq_base < 0) {=0A=
		dev_err(&pdev->dev, "PCH gpio: Failed to get IRQ base num\n");=0A=
		goto err_irq_alloc_descs;=0A=
	}=0A=
=0A=
	chip->irq_base =3D irq_base;=0A=
=0A=
	ret =3D request_irq(pdev->irq, pch_gpio_handler,=0A=
			     IRQF_SHARED, KBUILD_MODNAME, chip);=0A=
	if (ret !=3D 0) {=0A=
		dev_err(&pdev->dev,=0A=
			"%s request_irq failed\n", __func__);=0A=
		goto err_request_irq;=0A=
	}=0A=
=0A=
	for (i =3D 0; i < GPIO_NUM_PINS; i++) {=0A=
		set_irq_chip_and_handler_name(i + irq_base, &pch_irqchip,=0A=
					handle_simple_irq, "pch");=0A=
		set_irq_chip_data(i + irq_base, chip);=0A=
	}=0A=
=0A=
	/* Initialize interrupt ien register */=0A=
	iowrite32(0, &chip->reg->ien);=0A=
=0A=
	return 0;=0A=
=0A=
err_request_irq:=0A=
	irq_free_descs(irq_base, GPIO_NUM_PINS);=0A=
=0A=
err_irq_alloc_descs:=0A=
	ret =3D gpiochip_remove(&chip->gpio);=0A=
	if (ret)=0A=
		dev_err(&pdev->dev, "%s gpiochip_remove failed\n", __func__);=0A=
=0A=
err_gpiochip_add:=0A=
	pci_iounmap(pdev, chip->base);=0A=
=0A=
err_iomap:=0A=
	pci_release_regions(pdev);=0A=
=0A=
err_request_regions:=0A=
	pci_disable_device(pdev);=0A=
=0A=
err_pci_enable:=0A=
	kfree(chip);=0A=
	dev_err(&pdev->dev, "%s Failed returns %d\n", __func__, ret);=0A=
	return ret;=0A=
}=0A=
=0A=
static void __devexit pch_gpio_remove(struct pci_dev *pdev)=0A=
{=0A=
	int err;=0A=
	struct pch_gpio *chip =3D pci_get_drvdata(pdev);=0A=
=0A=
	err =3D gpiochip_remove(&chip->gpio);=0A=
	if (err)=0A=
		dev_err(&pdev->dev, "Failed gpiochip_remove\n");=0A=
=0A=
	pci_iounmap(pdev, chip->base);=0A=
	pci_release_regions(pdev);=0A=
	pci_disable_device(pdev);=0A=
	kfree(chip);=0A=
}=0A=
=0A=
#ifdef CONFIG_PM=0A=
static int pch_gpio_suspend(struct pci_dev *pdev, pm_message_t state)=0A=
{=0A=
	s32 ret;=0A=
	struct pch_gpio *chip =3D pci_get_drvdata(pdev);=0A=
=0A=
	pch_gpio_save_reg_conf(chip);=0A=
	pch_gpio_restore_reg_conf(chip);=0A=
=0A=
	ret =3D pci_save_state(pdev);=0A=
	if (ret) {=0A=
		dev_err(&pdev->dev, "pci_save_state Failed-%d\n", ret);=0A=
		return ret;=0A=
	}=0A=
	pci_disable_device(pdev);=0A=
	pci_set_power_state(pdev, PCI_D0);=0A=
	ret =3D pci_enable_wake(pdev, PCI_D0, 1);=0A=
	if (ret)=0A=
		dev_err(&pdev->dev, "pci_enable_wake Failed -%d\n", ret);=0A=
=0A=
	return 0;=0A=
}=0A=
=0A=
static int pch_gpio_resume(struct pci_dev *pdev)=0A=
{=0A=
	s32 ret;=0A=
	struct pch_gpio *chip =3D pci_get_drvdata(pdev);=0A=
=0A=
	ret =3D pci_enable_wake(pdev, PCI_D0, 0);=0A=
=0A=
	pci_set_power_state(pdev, PCI_D0);=0A=
	ret =3D pci_enable_device(pdev);=0A=
	if (ret) {=0A=
		dev_err(&pdev->dev, "pci_enable_device Failed-%d ", ret);=0A=
		return ret;=0A=
	}=0A=
	pci_restore_state(pdev);=0A=
=0A=
	iowrite32(0x01, &chip->reg->reset);=0A=
	iowrite32(0x00, &chip->reg->reset);=0A=
	pch_gpio_restore_reg_conf(chip);=0A=
=0A=
	return 0;=0A=
}=0A=
#else=0A=
#define pch_gpio_suspend NULL=0A=
#define pch_gpio_resume NULL=0A=
#endif=0A=
=0A=
#define PCI_VENDOR_ID_ROHM             0x10DB=0A=
static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) =3D {=0A=
	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },=0A=
	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },=0A=
	{ 0, }=0A=
};=0A=
MODULE_DEVICE_TABLE(pci, pch_gpio_pcidev_id);=0A=
=0A=
static struct pci_driver pch_gpio_driver =3D {=0A=
	.name =3D "pch_gpio",=0A=
	.id_table =3D pch_gpio_pcidev_id,=0A=
	.probe =3D pch_gpio_probe,=0A=
	.remove =3D __devexit_p(pch_gpio_remove),=0A=
	.suspend =3D pch_gpio_suspend,=0A=
	.resume =3D pch_gpio_resume=0A=
};=0A=
=0A=
static int __init pch_gpio_pci_init(void)=0A=
{=0A=
	return pci_register_driver(&pch_gpio_driver);=0A=
}=0A=
module_init(pch_gpio_pci_init);=0A=
=0A=
static void __exit pch_gpio_pci_exit(void)=0A=
{=0A=
	pci_unregister_driver(&pch_gpio_driver);=0A=
}=0A=
module_exit(pch_gpio_pci_exit);=0A=
=0A=
MODULE_DESCRIPTION("PCH GPIO PCI Driver");=0A=
MODULE_LICENSE("GPL");=0A=

------=_NextPart_000_00EF_01CC1400.D7CE2A70
Content-Type: text/plain;
	name="TP_result.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="TP_result.txt"

[root@localhost morinaga]# ./a.out 
fd=3
write=2
fd=3
write=7
fd=3
read=1 val=1
waiting for interrupt...poll=1 revent=0x1
lseek=0
read=1 val=1
OK (1, High)
fd=3
read=1 val=1
waiting for interrupt...poll=1 revent=0x1
lseek=0
read=1 val=1
OK (1, High)
fd=3
read=1 val=1
waiting for interrupt...poll=1 revent=0x1
lseek=0
read=1 val=1
OK (1, High)
[root@localhost morinaga]# 


------=_NextPart_000_00EF_01CC1400.D7CE2A70--

